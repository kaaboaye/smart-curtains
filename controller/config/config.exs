# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :controller, ecto_repos: [Controller.Repo]

config :controller, Controller.Repo,
  adapter: Sqlite.Ecto2,
  database: "database-#{Mix.target()}.sqlite3"

import_config "#{Mix.target()}.exs"
