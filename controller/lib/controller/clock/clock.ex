defmodule Controller.Clock do
  use GenServer
  require Logger

  @light_sensor ControllerRpi3.LightSensor
  @motor ControllerRpi3.Motor
  # @light_sensor Controller.Clock.Mocks.LightSensor
  # @motor Controller.Clock.Mocks.Motor

  def do_job({:continue, light_sensor, motor}) do
    alias Controller.Settings

    {:ok, light} = @light_sensor.read(light_sensor)
    # direction = @motor.state(motor)

    desired = Settings.get_current_desired_value()

    :ok =
      cond do
        Kernel.abs(light - desired) <= 20 -> @motor.go(motor, :stop)
        light - desired > 20 -> @motor.go(motor, :left)
        light - desired < -20 -> @motor.go(motor, :right)
      end

    Logger.debug("MOTOR LIGHT: #{light} DESIRED: #{desired}")
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    {:ok, light_sensor} = @light_sensor.start_link()
    {:ok, motor} = @motor.start_link()

    state = {:continue, light_sensor, motor}

    do_job(state)
    schedule_work()

    {:ok, state}
  end

  def handle_info(:do_job, {:continue, _, _} = state) do
    do_job(state)
    schedule_work()
    {:noreply, state}
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
