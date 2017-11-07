defmodule WhatsHoppinWeb.PageController do
  use WhatsHoppinWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
