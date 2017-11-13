defmodule WhatsHoppin.Forum.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias WhatsHoppin.Forum.Message


  schema "messages" do
    field :content, :string
    belongs_to :user, WhatsHoppin.Forum.User
    belongs_to :brewery, WhatsHoppin.Locations.Brewery
    belongs_to :style, WhatsHoppin.Beer.Style

    timestamps()
  end

  @doc false
  def changeset(%Message{} = message, attrs) do
    message
    |> cast(attrs, [:content, :user_id, :brewery_id, :style_id])
    # |> validate_ids(:brewery_id, :style_id)
    |> validate_required([:content, :user_id])
  end

  # TODO get this working
  # def validate_ids(message, brewery_id, style_id) do
  #   case valid_ids(brewery_id, style_id) do
  #     {:ok, _} -> []
  #     {:error, msg} -> [{field, options[:message] || msg}]
  #   end
  # end

  # def valid_ids(brewery_id, style_id) do
  #   has_brewery? = (brewery_id != -1)
  #   has_style? = (style_id != -1)

  #   # xor, must have exaxctly one of the two ids
  #   if (has_brewery? && !has_style?) || (!has_brewery? && has_style?) do
  #     {:ok, [brewery_id, style_id]}
  #   else
  #     {:error, "Must have either a brewery_id or style_id, but not both"}
  #   end
  # end
end





