defmodule Controller.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:id, :string, primary_key: true)
    field(:desired_value, :float)
    field(:scheduled_at, :time)

    timestamps(inserted_at: false)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:scheduled_at, :desired_value])
    |> validate_required([:scheduled_at, :desired_value])
  end
end
