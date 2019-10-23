defmodule DomainTrackingWeb.Router do
  use DomainTrackingWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DomainTrackingWeb do
    pipe_through :api
    post "/visited_links", DomainController, :create
    get "/visited_domains", DomainController, :show
  end
end
