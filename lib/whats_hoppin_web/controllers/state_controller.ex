defmodule WhatsHoppinWeb.StateController do
  use WhatsHoppinWeb, :controller
  alias WhatsHoppin.Locations

  def index(conn, _params) do
    states = Enum.sort(Locations.list_states())
    render(conn, "index.html", states: states)
  end

  def show(conn, %{"id" => id}) do
    state = Locations.get_state!(id)
    breweries = Locations.get_breweries_by_state(state.name)
    render(conn, "show.html", state: state, breweries_in_state: breweries)
  end
end
