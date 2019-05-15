use Mix.Config

config :controller, Controller.Repo, database: "database-#{Mix.env()}.sqlite3"

config :controller, ControllerWeb.Endpoint,
  code_reloader: true,
  pubsub: [name: Controller.PubSub, adapter: Phoenix.PubSub.PG2]
