defmodule WhatsHoppin.Forum.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias WhatsHoppin.Forum.Message


  schema "messages" do
    field :content, :string
    field :forum_id, :string
    belongs_to :user, WhatsHoppin.Forum.User

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:content, :forum_id, :user_id])
    |> validate_required([:content, :forum_id]) # TODO require user_id, fix migration too
  end
end
