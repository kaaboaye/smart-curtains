defmodule Controller.Settings do
  @moduledoc """
  The Settings context.
  """
  use Amnesia
  alias Controller.Database.Setting

  @keys %{
    "custom_desired_value" => :custom_desired_value,
    "enable" => :enable
  }

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

  def set(:enable, value) do
    with {:ok, value} <- Ecto.Type.cast(:boolean, value) do
      setting =
        Amnesia.transaction! do
          %Setting{
            key: :enable,
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
    case @keys[key] do
      nil -> nil
      key -> set(key, value)
    end
  end

  def get(key) when is_atom(key), do: Amnesia.transaction(do: Setting.read!(key))

  def get_from_string(key) do
    case @keys[key] do
      nil -> nil
      key -> get(key)
    end
  end

  def get_current_desired_value do
    import Controller.Tasks, only: [list_past_tasks: 0, time_to_datetime: 1]

    custom_setting = get(:custom_desired_value)

    current_task =
      with [_ | _] = tasks <- list_past_tasks() do
        Enum.min_by(tasks, fn t ->
          DateTime.diff(DateTime.utc_now(), time_to_datetime(t.scheduled_at))
        end)
      else
        [] -> nil
      end

    if is_nil(current_task) or
         DateTime.diff(custom_setting.updated_at, time_to_datetime(current_task.scheduled_at)) >=
           0,
       do: custom_setting.value,
       else: current_task.desired_value
  end
end
