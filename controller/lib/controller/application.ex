defmodule Controller.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Controller.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  defp children(platform) do
    [
      {ControllerWeb.Endpoint, []}
      | platform_children(platform)
    ]
  end

  defp platform_children(:host) do
    []
  end

  defp platform_children(:rpi3) do
    Task.start(fn ->
      Process.sleep(5000)
      Nerves.Network.status("eth0") |> IO.inspect()
    end)

    [
      # Starts a worker by calling: Controller.Worker.start_link(arg)
      # {Controller.Worker, arg},

      {Controller.Clock, []}
    ]
  end
end
