defmodule WhatsHoppinWeb.BreweryController do
  use WhatsHoppinWeb, :controller

  alias WhatsHoppin.Locations
  alias WhatsHoppin.Beer
  alias WhatsHoppin.Forum
  
  def show(conn, %{"id" => id}) do
    brewery = Locations.get_brewery!(id)
    beers = Beer.get_beers_within_brewery(brewery.brewery_id)
    messages = Forum.list_messages_for_forum(brewery.brewery_id)
    render(conn, "show.html", brewery: brewery, brewery_beers: beers, messages: messages)
  end

  # TODO put this somewhere else, do we need this?
  def show_state_index(conn, state) do
    breweries = Locations.get_breweries_by_state(to_string(state))
    conn
    |> assign(:breweries_in_state, breweries)
    |> render("state_index.html")
  end
end
