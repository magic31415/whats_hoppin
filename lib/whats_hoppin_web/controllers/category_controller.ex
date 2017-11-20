defmodule WhatsHoppinWeb.CategoryController do
  use WhatsHoppinWeb, :controller
  alias WhatsHoppin.Beer

  def index(conn, _params) do
    categories = Beer.list_categories()
    render(conn, "index.html", categories: categories)
  end

  def show(conn, %{"id" => id}) do
    category = Beer.get_category!(id)
    render(conn, "show.html", category: category)
  end
end
