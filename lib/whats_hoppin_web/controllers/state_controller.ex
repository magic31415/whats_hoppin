defmodule WhatsHoppinWeb.StateController do
  use WhatsHoppinWeb, :controller

  alias WhatsHoppin.Locations
  alias WhatsHoppin.Repo

  def index(conn, _params) do
    states = Application.get_env(:whats_hoppin, :states)
    render(conn, "index.html", states: states)
  end

  def show(conn, params) do
  	breweries = Locations.get_breweries_by_state("Alabama")
  	conn
  	|> render("show.html", breweries_in_state: breweries)
  end

 end