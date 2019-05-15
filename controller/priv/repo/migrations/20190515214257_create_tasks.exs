defmodule Controller.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add(:scheduled_at, :time, null: false)
      add(:desired_value, :float, null: false)

      timestamps()
    end
  end
end
