defmodule ControllerWeb.TaskView do
  use ControllerWeb, :view
  alias ControllerWeb.TaskView

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{
      id: task.id,
      scheduled_at: task.scheduled_at,
      desired_value: task.desired_value,
      updated_at: task.updated_at
    }
  end
end
