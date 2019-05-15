defmodule ControllerWeb.Router do
  use ControllerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", ControllerWeb do
    pipe_through(:api)
  end
end
