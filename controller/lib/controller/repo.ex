defmodule Controller.Repo do
  use Ecto.Repo,
    otp_app: :controller,
    adapter: Sqlite.Ecto2
end
