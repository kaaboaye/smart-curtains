defmodule Controller.Clock.Mocks.LightSensor do
  use Agent

  def start_link(_opts \\ []), do: Agent.start_link(fn -> nil end, name: __MODULE__)
  def read, do: {:ok, 100}
end
