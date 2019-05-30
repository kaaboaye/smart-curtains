if Code.ensure_loaded?(ElixirALE.GPIO) do
  defmodule ControllerRpi3.Motor do
    use GenServer
    alias ElixirALE.GPIO

    def go(pid, direction) when direction in [:stop, :left, :right] do
      GenServer.call(pid, direction)
    end

    def start_link(_opts \\ []) do
      GenServer.start_link(__MODULE__, [])
    end

    def init(_) do
      {:ok, io1} = GPIO.start_link(17, :output)
      {:ok, io2} = GPIO.start_link(27, :output)

      :ok = GPIO.write(io1, 0)
      :ok = GPIO.write(io2, 0)

      {:ok, {:ok, io1, io2}}
    end

    def handle_call(:stop, _from, {:ok, io1, io2} = state) do
      :ok = GPIO.write(io1, 0)
      :ok = GPIO.write(io2, 0)

      {:reply, :ok, state}
    end

    def handle_call(:left, _from, {:ok, io1, io2} = state) do
      :ok = GPIO.write(io2, 0)
      :ok = GPIO.write(io1, 1)

      {:reply, :ok, state}
    end

    def handle_call(:right, _from, {:ok, io1, io2} = state) do
      :ok = GPIO.write(io1, 0)
      :ok = GPIO.write(io2, 1)

      {:reply, :ok, state}
    end
  end
end
