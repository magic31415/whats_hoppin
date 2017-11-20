#
# Session Controller from
# https://github.com/NatTuck/nu_mart
#
defmodule WhatsHoppinWeb.SessionController do
  use WhatsHoppinWeb, :controller

  def login(conn, %{"username" => username, "password" => password}) do
    user = WhatsHoppin.Forum.User.get_and_auth_user(username, password)

    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Logged in as #{user.username}")
      |> redirect(to: page_path(conn, :index)) # TODO
    else
      conn
      |> put_session(:user_id, nil)
      |> put_flash(:error, "Bad username and password combination.")
      |> redirect(to: page_path(conn, :index)) # TODO
    end
  end

  def logout(conn, _args) do
    conn
    |> put_session(:user_id, nil)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: page_path(conn, :index)) # TODO
  end
end
