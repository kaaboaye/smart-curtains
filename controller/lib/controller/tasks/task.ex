defmodule Controller.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :desired_value, :float
    field :scheduled_at, :time

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:scheduled_at, :desired_value])
    |> validate_required([:scheduled_at, :desired_value])
  end
end
