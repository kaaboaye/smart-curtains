defmodule Controller.Clock.LightSensor do
  case Mix.target() do
    :host -> @sensor Controller.Clock.Mocks.LightSensor
    :rpi3 -> @sensor ControllerRpi3.LightSensor
  end

  def start_link(opts \\ []), do: @sensor.start_link(opts)
  def read, do: @sensor.read()
end
