use Mix.Config

config :controller, ControllerWeb.Endpoint,
  code_reloader: true,
  pubsub: [name: Controller.PubSub, adapter: Phoenix.PubSub.PG2]
