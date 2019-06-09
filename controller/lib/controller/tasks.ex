defmodule Controller.Tasks do
  @moduledoc """
  The Tasks context.
  """

  use Amnesia

  alias Ecto.Changeset
  alias Controller.Tasks.Task, as: EctoTask
  alias Controller.Database.Task
  alias Controller.UniqueId

  def list_tasks do
    Amnesia.transaction! do
      Task.stream()
      |> Stream.map(fn t ->
        Map.put(t, :id, UniqueId.to_string(t.id))
      end)
      |> Enum.to_list()
    end
  end

  def list_past_tasks do
    list_tasks()
    |> Enum.filter(fn t ->
      DateTime.diff(DateTime.utc_now(), time_to_datetime(t.scheduled_at)) >= 0
    end)
  end

  def time_to_datetime(time) do
    DateTime.utc_now()
    |> Map.put(:hour, time.hour)
    |> Map.put(:minute, time.minute)
    |> Map.put(:second, time.second)
    |> Map.put(:microsecond, time.microsecond)
  end

  def get_task(id) do
    with {:ok, id} <- UniqueId.to_binary(id),
         %{} = task <- Amnesia.transaction!(do: Task.read(id)) do
      Map.put(task, :id, UniqueId.to_string(task.id))
    else
      :error -> {:error, :bad_request}
      nil -> {:error, :not_found}
    end
  end

  def create_task(attrs) do
    changeset =
      %EctoTask{
        id: UniqueId.generate_id(),
        updated_at: DateTime.utc_now()
      }
      |> EctoTask.changeset(attrs)

    with %{valid?: true} <- changeset do
      task = Changeset.apply_changes(changeset)

      task =
        Amnesia.transaction! do
          task
          |> from_ecto_task()
          |> Task.write!()
        end

      {:ok, Map.put(task, :id, UniqueId.to_string(task.id))}
    else
      err -> {:error, err}
    end
  end

  def update_task(id, attrs) do
    with %{} = task <- get_task(id),
         task <- to_ecto_task(task),
         %{valid?: true} = changeset <- EctoTask.changeset(task, attrs),
         task <- Changeset.apply_changes(changeset) do
      task =
        Amnesia.transaction! do
          task = from_ecto_task(task)
          task = Map.put(task, :id, UniqueId.to_binary!(task.id))

          Task.write!(task)
        end

      task = Map.put(task, :id, UniqueId.to_string(task.id))

      {:ok, task}
    else
      %Changeset{} = changeset -> {:error, changeset}
      nil -> {:error, :not_found}
    end
  end

  def delete_task(id) do
    with {:ok, id} <- UniqueId.to_binary(id) do
      Amnesia.transaction do
        Task.delete(id)
      end

      :ok
    else
      :error -> {:error, :bad_request}
    end
  end

  def to_ecto_task(task) do
    %EctoTask{}
    |> EctoTask.changeset(task |> Map.from_struct())
    |> Changeset.apply_changes()
    |> Map.put(:id, task.id)
    |> Map.put(:updated_at, task.updated_at)
  end

  defp from_ecto_task(task) do
    %Task{
      id: task.id,
      desired_value: task.desired_value,
      scheduled_at: task.scheduled_at,
      updated_at: task.updated_at
    }
  end
end
