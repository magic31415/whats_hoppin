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

    resources "/categories", CategoryController, only: [:show, :index]
    resources "/styles", StyleController, only: [:show, :index]

    resources "/states", StateController, only: [:index, :show]
    resources "/breweries", BreweryController, only: [:show, :index]

	resources "/messages", MessageController

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", WhatsHoppinWeb do
  #   pipe_through :api
  # end
end
