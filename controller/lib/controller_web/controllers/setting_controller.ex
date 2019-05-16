defmodule ControllerWeb.SettingController do
  use ControllerWeb, :controller

  alias Controller.Settings

  action_fallback(ControllerWeb.FallbackController)

  def index(conn, _params) do
    settings = Settings.get_all()
    render(conn, "index.json", settings: settings)
  end

  # def create(conn, %{"task" => task_params}) do
  #   task_params = map_task(task_params)

  #   with {:ok, %Task{} = task} <- Tasks.create_task(task_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", Routes.task_path(conn, :show, task))
  #     |> render("show.json", task: task)
  #   end
  # end

  def show(conn, %{"id" => key}) do
    with %{} = setting <- Settings.get_from_string(key) do
      render(conn, "show.json", setting: setting)
    end
    |> IO.inspect()
  end

  # def update(conn, %{"id" => id, "task" => task_params}) do
  #   with %{} = task <- Tasks.get_task(id),
  #        {:ok, %Task{} = task} <- Tasks.update_task(task, task_params) do
  #     render(conn, "show.json", task: task)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   with %{} = task <- Tasks.get_task(id),
  #        {:ok, %Task{}} <- Tasks.delete_task(task) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
