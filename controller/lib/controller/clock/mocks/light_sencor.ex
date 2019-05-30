defmodule Controller.Clock.Mocks.LightSensor do
  def start_link(_opts \\ []), do: {:ok, {:light_sensor_mock, 100}}
  def read({:light_sensor_mock, value}), do: {:ok, value}

  def set({:light_sensor_mock, _value}, value), do: {:light_sensor_mock, value}
end
