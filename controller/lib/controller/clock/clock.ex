defmodule Controller.Clock do
  use GenServer
  require Logger

  case Mix.target() do
    :host ->
      @light_sensor Controller.Clock.Mocks.LightSensor
      @motor Controller.Clock.Mocks.Motor

    :rpi3 ->
      @light_sensor ControllerRpi3.LightSensor
      @motor ControllerRpi3.Motor
  end

  def do_job do
    alias Controller.Settings

    with {:ok, light} <- @light_sensor.read() do
      desired = Settings.get_current_desired_value()
      direction = @motor.direction()

      :ok =
        cond do
          Kernel.abs(light - desired) <= 20 -> @motor.direction(:stop)
          light - desired > 20 -> @motor.direction(:left)
          light - desired < -20 -> @motor.direction(:right)
        end

      Logger.info("MOTOR: #{direction} LIGHT: #{light} DESIRED: #{desired}")
    else
      _ -> Logger.info("light sensor not ready")
    end
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    schedule_work()

    {:ok, :continue}
  end

  def handle_info(:do_job, :continue) do
    do_job()
    schedule_work()
    {:noreply, :continue}
  end

  def handle_info(:do_job, :stop) do
    {:stop, :stopped, :stopped}
  end

  def handle_call(:stop, _from, _state) do
    {:noreply, :stop}
  end

  defp schedule_work do
    Process.send_after(self(), :do_job, 100)
  end
end
