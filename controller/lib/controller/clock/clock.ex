defmodule Controller.Clock do
  use GenServer

  require Logger

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    do_job()
    schedule_work()
    {:ok, nil}
  end

  def handle_info(:collect_orders, _) do
    do_job()
    schedule_work()
    {:noreply, nil}
  end

  def do_job do
    IO.puts("HI!#{NaiveDateTime.utc_now()}")
  end

  defp schedule_work do
    # Process.send_after(self(), :collect_orders, 100)
  end
end
