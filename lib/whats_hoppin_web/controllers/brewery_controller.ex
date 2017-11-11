defmodule WhatsHoppinWeb.BreweryController do
  use WhatsHoppinWeb, :controller

  alias WhatsHoppin.Locations
  alias WhatsHoppin.Locations.Brewery
  alias WhatsHoppin.Repo

  def index(conn, _params) do
    breweries = Locations.list_breweries()
    render(conn, "index.html", breweries: breweries)
  end

  def new(conn, _params) do
    changeset = Locations.change_brewery(%Brewery{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"brewery" => brewery_params}) do
    case Locations.create_brewery(brewery_params) do
      {:ok, brewery} ->
        conn
        |> put_flash(:info, "Brewery created successfully.")
        |> redirect(to: brewery_path(conn, :show, brewery))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    brewery = Locations.get_brewery!(id)
    render(conn, "show.html", brewery: brewery)
  end

  def show_state_index(conn, state) do
    breweries = Locations.get_breweries_by_state(to_string(state))
    conn
    |> assign(:breweries_in_state, breweries)
    |> render("state_index.html")
  end

  def edit(conn, %{"id" => id}) do
    brewery = Locations.get_brewery!(id)
    changeset = Locations.change_brewery(brewery)
    render(conn, "edit.html", brewery: brewery, changeset: changeset)
  end

  def update(conn, %{"id" => id, "brewery" => brewery_params}) do
    brewery = Locations.get_brewery!(id)

    case Locations.update_brewery(brewery, brewery_params) do
      {:ok, brewery} ->
        conn
        |> put_flash(:info, "Brewery updated successfully.")
        |> redirect(to: brewery_path(conn, :show, brewery))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", brewery: brewery, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    brewery = Locations.get_brewery!(id)
    {:ok, _brewery} = Locations.delete_brewery(brewery)

    conn
    |> put_flash(:info, "Brewery deleted successfully.")
    |> redirect(to: brewery_path(conn, :index))
  end
end
