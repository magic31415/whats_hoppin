defmodule WhatsHoppinWeb.StyleController do
  use WhatsHoppinWeb, :controller

  alias WhatsHoppin.Beer
  alias WhatsHoppin.Beer.Style
  alias WhatsHoppin.Forum

  # def index(conn, _params) do
  #   styles = Beer.list_styles()
  #   render(conn, "index.html", styles: styles)
  # end

  # def new(conn, _params) do
  #   changeset = Beer.change_style(%Style{})
  #   render(conn, "new.html", changeset: changeset)
  # end

  # def create(conn, %{"style" => style_params}) do
  #   case Beer.create_style(style_params) do
  #     {:ok, style} ->
  #       conn
  #       |> put_flash(:info, "Style created successfully.")
  #       |> redirect(to: style_path(conn, :show, style))
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

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

  # def edit(conn, %{"id" => id}) do
  #   style = Beer.get_style!(id)
  #   changeset = Beer.change_style(style)
  #   render(conn, "edit.html", style: style, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "style" => style_params}) do
  #   style = Beer.get_style!(id)

  #   case Beer.update_style(style, style_params) do
  #     {:ok, style} ->
  #       conn
  #       |> put_flash(:info, "Style updated successfully.")
  #       |> redirect(to: style_path(conn, :show, style))
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", style: style, changeset: changeset)
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   style = Beer.get_style!(id)
  #   {:ok, _style} = Beer.delete_style(style)

  #   conn
  #   |> put_flash(:info, "Style deleted successfully.")
  #   |> redirect(to: style_path(conn, :index))
  # end
end
