defmodule Controller.Clock.Motor do
  case Mix.target() do
    :host -> @motor Controller.Clock.Mocks.Motor
    :rpi3 -> @motor ControllerRpi3.Motor
  end

  def start_link(opts \\ []), do: @motor.start_link(opts)

  def direction, do: @motor.direction()
  def direction(direction), do: @motor.direction(direction)
end
