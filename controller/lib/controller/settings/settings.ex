defmodule Controller.Settings do
  @moduledoc """
  The Settings context.
  """
  use Amnesia
  alias Controller.Database.Setting

  def get_all do
    Amnesia.transaction do
      Setting.stream() |> Map.new(fn x -> {x.key, x} end)
    end
  end

  def list_all do
    Amnesia.transaction do
      Setting.stream() |> Enum.to_list()
    end
  end

  def set(:custom_desired_value, value) do
    with {:ok, value} <- Ecto.Type.cast(:float, value) do
      setting =
        Amnesia.transaction! do
          %Setting{
            key: :custom_desired_value,
            value: value,
            updated_at: DateTime.utc_now()
          }
          |> Setting.write!()
        end

      {:ok, setting}
    else
      :error -> {:error, :bad_request}
    end
  end

  def set_from_string(key, value) do
    case key do
      "custom_desired_value" -> set(:custom_desired_value, value)
      _ -> nil
    end
  end

  def get(key) when key == :custom_desired_value do
    Amnesia.transaction(do: Setting.read!(key))
  end

  def get_from_string(key) do
    case key do
      "custom_desired_value" -> get(:custom_desired_value)
      _ -> nil
    end
  end
end
