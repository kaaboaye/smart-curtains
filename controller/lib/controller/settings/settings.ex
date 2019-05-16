defmodule Controller.Settings do
  @moduledoc """
  The Settings context.
  """
  use Amnesia
  alias Controller.Database.Setting

  def set(:custom_desired_value, value) do
    Amnesia.transaction! do
      %Setting{
        key: :custom_desired_value,
        value: value,
        updated_at: DateTime.utc_now()
      }
      |> Setting.write!()
    end
  end

  def get(key) when key == :custom_desired_value do
    Amnesia.transaction do
      Setting.read!(key)
    end
  end

  def get_all do
    Amnesia.transaction do
      Setting.stream() |> Map.new(fn x -> {x.key, x} end)
    end
  end
end
