defmodule ControllerWeb.TaskController do
  use ControllerWeb, :controller

  alias Controller.Tasks
  alias Controller.Database.Task

  action_fallback(ControllerWeb.FallbackController)

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, %{"task" => task_params}) do
    with {:ok, %Task{} = task} <- Tasks.create_task(task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.task_path(conn, :show, task))
      |> render("show.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    with %{} = task <- Tasks.get_task(id) do
      render(conn, "show.json", task: task)
    end
  end

  def update(conn, %{"id" => id} = attrs) do
    with {:ok, task_params} <- Map.fetch(attrs, "task"),
         {:ok, task} <- Tasks.update_task(id, task_params) do
      render(conn, "show.json", task: task)
    else
      :error -> {:error, :bad_request}
      err -> err
    end
  end

  def delete(conn, %{"id" => id}) do
    with :ok <- Tasks.delete_task(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
