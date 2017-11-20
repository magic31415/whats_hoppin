defmodule WhatsHoppinWeb.Router do
  use WhatsHoppinWeb, :router
  import WhatsHoppinWeb.Plugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_user
  end

  scope "/", WhatsHoppinWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/categories", CategoryController, only: [:show, :index]
    resources "/styles", StyleController, only: [:show]

    resources "/states", StateController, only: [:index, :show]
    resources "/breweries", BreweryController, only: [:show]

    # TODO which resources
    resources "/users", UserController, only: [:edit, :update, :new, :create]

    post "/sessions", SessionController, :login
    delete "/sessions", SessionController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", WhatsHoppinWeb do
  #   pipe_through :api
  # end
end
