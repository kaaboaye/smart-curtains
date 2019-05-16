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
    task_params = map_task(task_params)

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

  # def update(conn, %{"id" => id, "task" => task_params}) do
  #   with %{} = task <- Tasks.get_task(id),
  #        {:ok, %Task{} = task} <- Tasks.update_task(task, task_params) do
  #     render(conn, "show.json", task: task)
  #   end
  # end

  def delete(conn, %{"id" => id}) do
    with :ok <- Tasks.delete_task(id) do
      send_resp(conn, :no_content, "")
    end
    |> IO.inspect
  end

  defp map_task(task) do
    %{
      scheduled_at: task["scheduledAt"],
      desired_value: task["desiredValue"]
    }
  end
end
