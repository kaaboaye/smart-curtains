defmodule Controller.Clock.Mocks.Motor do
  def start_link(_opts \\ []) do
    {:ok, state} = Agent.start_link(fn -> :stop end, [])
    {:ok, {:motor, state}}
  end

  def go({:motor, agent}, :stop) do
    Agent.update(agent, fn _ -> :stop end)
    :ok
  end

  def go({:motor, agent}, :left) do
    Agent.update(agent, fn _ -> :left end)
    :ok
  end

  def go({:motor, agent}, :right) do
    Agent.update(agent, fn _ -> :right end)
    :ok
  end

  def state({:motor, pid}) do
    Agent.get(pid, & &1)
  end
end
