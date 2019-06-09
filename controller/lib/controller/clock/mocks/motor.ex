defmodule Controller.Clock.Mocks.Motor do
  def start_link(_opts \\ []) do
    {:ok, _state} = Agent.start_link(fn -> :stop end, name: __MODULE__)
    {:ok, :mock_motor_pid}
  end

  def direction(:stop) do
    Agent.update(__MODULE__, fn _ -> :stop end)
    :ok
  end

  def direction(:left) do
    Agent.update(__MODULE__, fn _ -> :left end)
    :ok
  end

  def direction(:right) do
    Agent.update(__MODULE__, fn _ -> :right end)
    :ok
  end

  def direction do
    Agent.get(__MODULE__, & &1)
  end
end
