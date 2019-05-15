use Mix.Config

config :controller, Controller.Repo,
  adapter: Sqlite.Ecto2,
  database: "database-#{Mix.env()}.sqlite3"

config :controller, ControllerWeb.Endpoint,
  pubsub: [name: Controller.PubSub, adapter: Phoenix.PubSub.PG2]
