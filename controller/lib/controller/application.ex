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
      Process.sleep(2000)

      IO.puts("""

      Connecting to Wi-Fi

      """)

      Nerves.Network.setup("wlan0", ssid: "Ninja", psk: "55806978")

      Process.sleep(5000)

      IO.puts("""

      Network info

      """)

      Nerves.Network.status("eth0") |> Map.get(:ipv4_address) |> IO.inspect()
      Nerves.Network.status("wlan0") |> Map.get(:ipv4_address) |> IO.inspect()
    end)

    Task.start(fn ->
      Process.sleep(3000)
      Controller.Database.create()
      Controller.Settings.set(:custom_desired_value, 100)
    end)

    [
      # Starts a worker by calling: Controller.Worker.start_link(arg)
      # {Controller.Worker, arg},
    ]
  end
end
