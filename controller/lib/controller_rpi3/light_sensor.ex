if Code.ensure_loaded?(ElixirALE.I2C) do
  defmodule ControllerRpi3.LightSensor do
    use GenServer
    alias ElixirALE.I2C

    def read do
      GenServer.call(__MODULE__, :read)
    end

    def start_link(_opts \\ []) do
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def init(_) do
      Process.send(__MODULE__, :__power_on__, [])
      {:ok, :powering_on}
    end

    def handle_info(:__power_on__, :powering_on) do
      {:ok, i2c} = I2C.start_link("i2c-1", 0x39)
      I2C.write(i2c, <<0x80, 0x01>>)

      Process.send_after(__MODULE__, :__conf__, 2000)
      {:noreply, {i2c, :not_ready, :configuring}}
    end

    def handle_info(:__conf__, {i2c, :not_ready, :configuring}) do
      # set clock to 400 ms
      I2C.write(i2c, <<129, 0x6C>>)
      # control power on
      I2C.write(i2c, <<0x80, 3>>)
      # every cycle generate interrupts
      I2C.write(i2c, <<130, 0x1F>>)
      # gain = 16
      I2C.write(i2c, <<135, 0x02>>)

      {:noreply, {:ok, i2c}}
    end

    def handle_call(:read, _from, {:ok, i2c} = state) do
      use Bitwise

      <<ch0::16-little>> = I2C.write_read(i2c, <<212, 213>>, 2)
      <<ch1::16-little>> = I2C.write_read(i2c, <<214, 215>>, 2)

      scale = 4096

      ch0 = (ch0 * scale) >>> 16
      ch1 = (ch1 * scale) >>> 16

      ratio =
        if ch0 != 0 do
          (Integer.floor_div(ch1 <<< 10, ch0) + 1) >>> 1
        else
          0
        end

      {b, m} =
        cond do
          ratio >= 0 && ratio <= 0x009A -> {0x2148, 0x3D71}
          ratio <= 0x00C3 -> {0x2A37, 0x5B30}
          ratio <= 0x00E6 -> {0x18EF, 0x2DB9}
          ratio <= 0x0114 -> {0x0FDF, 0x199A}
          ratio > 0x0114 -> {0x0000, 0x0000}
        end

      lux = (ch0 * b - ch1 * m + 32768) >>> 16

      {:reply, {:ok, lux}, state}
    end

    def handle_call(:read, _from, state) do
      {:reply, {:error, :not_ready}, state}
    end

    def handle_call(:get_state, _from, state) do
      {:reply, state, state}
    end
  end
end
