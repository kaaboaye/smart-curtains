if Code.ensure_loaded?(ElixirALE.GPIO) do
  defmodule ControllerRpi3.Motor do
    use GenServer
    alias ElixirALE.GPIO

    def direction(direction) when direction in [:stop, :left, :right] do
      GenServer.call(__MODULE__, direction)
    end

    def direction do
      GenServer.call(__MODULE__, :state)
    end

    def start_link(_opts \\ []) do
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init(_) do
      {:ok, io1} = GPIO.start_link(17, :output)
      {:ok, io2} = GPIO.start_link(27, :output)

      :ok = GPIO.write(io1, 0)
      :ok = GPIO.write(io2, 0)

      {:ok, {:ok, :stop, io1, io2}}
    end

    def handle_call(:stop, _from, {:ok, _, io1, io2}) do
      :ok = GPIO.write(io1, 0)
      :ok = GPIO.write(io2, 0)

      {:reply, :ok, {:ok, :stop, io1, io2}}
    end

    def handle_call(:left, _from, {:ok, _, io1, io2}) do
      :ok = GPIO.write(io2, 0)
      :ok = GPIO.write(io1, 1)

      {:reply, :ok, {:ok, :left, io1, io2}}
    end

    def handle_call(:right, _from, {:ok, _, io1, io2}) do
      :ok = GPIO.write(io1, 0)
      :ok = GPIO.write(io2, 1)

      {:reply, :ok, {:ok, :right, io1, io2}}
    end

    def handle_call(:state, _from, {:ok, direction, _io1, _io2} = state) do
      {:reply, direction, state}
    end
  end
end
