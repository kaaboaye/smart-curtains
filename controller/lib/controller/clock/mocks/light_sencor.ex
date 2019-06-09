defmodule Controller.Clock.Mocks.LightSensor do
  def start_link(_opts \\ []), do: {:ok, :mock_light_sensor_pid}
  def read, do: {:ok, 100}
end
