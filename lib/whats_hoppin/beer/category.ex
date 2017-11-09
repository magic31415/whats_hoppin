defmodule WhatsHoppin.Beer.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias WhatsHoppin.Beer.Category


  schema "categories" do
    field :category_id, :integer
    field :desc, :string
    field :name, :string
    has_many :styles, WhatsHoppin.Beer.Style, foreign_key: :category_id

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:categoryId, :name, :desc])
    |> validate_required([:categoryId, :name, :desc])
  end
end
