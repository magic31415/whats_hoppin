defmodule WhatsHoppinWeb.ForumChannel do
  use WhatsHoppinWeb, :channel

  alias WhatsHoppin.Forum

  def join(chan, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # TODO Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  def handle_in("create", payload, socket) do
    Forum.create_message(payload)
    message = Map.take(Forum.get_latest_message!,
                       [:id, :content, :forum_id, :user_id])
    message = Map.put(message, :username, Forum.get_user!(message.user_id).username)
    broadcast! socket, "create", message
    {:noreply, socket}
  end

  def handle_in("update", payload, socket) do
    msg = Forum.get_message!(payload["id"])
    Forum.update_message(msg, %{content: payload["content"]})
    broadcast! socket, "update", payload
    {:noreply, socket}
  end

  def handle_in("delete", payload, socket) do
    msg = Forum.get_message!(payload["id"])
    Forum.delete_message(msg)
    broadcast! socket, "delete", payload
    {:noreply, socket}
  end
end
