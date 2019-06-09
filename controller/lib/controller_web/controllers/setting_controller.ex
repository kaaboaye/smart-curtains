defmodule ControllerWeb.SettingController do
  use ControllerWeb, :controller

  alias Controller.Settings

  action_fallback(ControllerWeb.FallbackController)

  defp get_light_reading do
    value = with {:ok, value} <- Controller.Clock.LightSensor.read(), do: value, else: (_ -> nil)
    %{key: "light_reading", updated_at: DateTime.utc_now(), value: value}
  end

  def index(conn, _params) do
    settings = Settings.get_all() |> Map.put(:light_reading, get_light_reading())
    render(conn, "index.json", settings: settings)
  end

  def show(conn, %{"id" => "light_reading"}) do
    render(conn, "show.json", setting: get_light_reading())
  end

  def show(conn, %{"id" => key}) do
    with %{} = setting <- Settings.get_from_string(key) do
      render(conn, "show.json", setting: setting)
    end
  end

  def update(conn, %{"id" => key} = attrs) do
    with {:ok, value} <- Map.fetch(attrs, "value"),
         {:ok, setting} <- Settings.set_from_string(key, value) do
      render(conn, "show.json", setting: setting)
    else
      :error -> {:error, :bad_request}
      nil -> {:error, :not_found}
    end
  end
end
