# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :controller, ecto_repos: [Controller.Repo]

config :controller, ControllerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xaD75htrQzhS9+xY6XxyRJDMUag4x4TZ90TPSHcUaKMaNldiWzg+72PbQHlnVCrw",
  render_errors: [view: ControllerWeb.ErrorView, accepts: ~w(json)],
  http: [port: 4000],
  debug_errors: true,
  check_origin: false,
  watchers: [],
  pubsub: [name: Controller.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

import_config "#{Mix.target()}.exs"
