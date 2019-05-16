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
          %Task{
            id: task.id,
            desired_value: task.desired_value,
            scheduled_at: task.scheduled_at,
            updated_at: task.updated_at
          }
          |> Task.write!()
        end

      {:ok, Map.put(task, :id, UniqueId.to_string(task.id))}
    else
      err -> {:error, err}
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
end
