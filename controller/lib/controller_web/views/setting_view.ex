defmodule ControllerWeb.SettingView do
  use ControllerWeb, :view
  alias ControllerWeb.SettingView

  def render("index.json", %{settings: settings}) do
    settings =
      settings
      |> Map.new(fn {k, v} ->
        {k, render_one(v, SettingView, "setting.json")}
      end)

    %{data: settings}
  end

  def render("show.json", %{setting: setting}) do
    %{data: render_one(setting, SettingView, "setting.json")}
  end

  def render("setting.json", %{setting: setting}) do
    %{key: setting.key, value: setting.value, updatedAt: setting.updated_at}
  end
end
