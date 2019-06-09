defmodule Controller.Clock do
  use GenServer
  require Logger

  alias Controller.Clock.LightSensor
  alias Controller.Clock.Motor

  def do_job do
    alias Controller.Settings

    if Settings.get(:enable).value do
      with {:ok, light} <- LightSensor.read() do
        desired = Settings.get_current_desired_value()
        direction = Motor.direction()

        :ok =
          cond do
            Kernel.abs(light - desired) <= 20 -> Motor.direction(:stop)
            light - desired > 20 -> Motor.direction(:left)
            light - desired < -20 -> Motor.direction(:right)
          end

        IO.puts("MOTOR: #{direction} LIGHT: #{light} DESIRED: #{desired}")
      else
        _ -> Logger.info("light sensor not ready")
      end
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
