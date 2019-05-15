defmodule Controller.Settings.Setting do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "settings" do
    field(:key, :string, primary_key: true)
    field(:value, :map)

    timestamps()
  end

  @doc false
  def changeset(setting, attrs) do
    setting
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end
end
