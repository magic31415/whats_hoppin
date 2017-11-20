defmodule WhatsHoppinWeb.StyleController do
  use WhatsHoppinWeb, :controller

  alias WhatsHoppin.Beer
  alias WhatsHoppin.Forum
  
  # TODO put this somewhere else
  defp get_random_beers_from_style(style_id) do
    Beer.path("beers", "styleId", style_id)
    |> Beer.add_attr_to_path("randomCount", 10)
    |> Beer.add_attr_to_path("order", "random")
    |> Beer.get_path

    # get path returns a tuple {data, numPages}
    |> elem(0)
  end

  def show(conn, %{"id" => id}) do
    style = Beer.get_style!(id)
    messages = Forum.list_messages_for_forum(style.styleId)

    random_beers = get_random_beers_from_style(style.styleId)
    # get some random beers from within the style to display on the show page as suggestions
    render(conn, "show.html", style: style, messages: messages, random_beers: random_beers)
  end
end
