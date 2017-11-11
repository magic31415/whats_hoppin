defmodule WhatsHoppinWeb.Router do
  use WhatsHoppinWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WhatsHoppinWeb do
    pipe_through :browser # Use the default browser stack

    resources "/breweries", BreweryController
    resources "/styles", StyleController
    resources "/categories", CategoryController

    resources "/breweries_by_state", StateController, only: [:index, :show]
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", WhatsHoppinWeb do
  #   pipe_through :api
  # end
end
