defmodule WhatsHoppinWeb.UserController do
  use WhatsHoppinWeb, :controller

  alias WhatsHoppin.Forum
  alias WhatsHoppin.Forum.User

  def set_current_user(conn, _params) do
    WhatsHoppinWeb.Plugs.fetch_user(conn, _params).assigns.current_user
  end

  def not_logged_in(conn) do
    conn
    |> redirect(to: category_path(conn, :index)) # TODO
  end

  def new(conn, _params) do
    changeset = Forum.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Forum.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  # def show(conn, %{"id" => id}) do
  #   user = Forum.get_user!(id)
  #   render(conn, "show.html", user: user)
  # end

  def edit(conn, %{"id" => id}) do
    user = Forum.get_user!(id)
    changeset = Forum.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Forum.get_user!(id)

    case Forum.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  # def delete(conn, %{"id" => id}) do
  #   user = Forum.get_user!(id)
  #   {:ok, _user} = Forum.delete_user(user)

  #   conn
  #   |> put_flash(:info, "User deleted successfully.")
  #   |> redirect(to: user_path(conn, :index))
  # end
end
