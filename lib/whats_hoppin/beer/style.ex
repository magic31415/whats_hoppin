defmodule WhatsHoppin.Beer.Style do
  use Ecto.Schema
  import Ecto.Changeset
  alias WhatsHoppin.Beer.Style


  schema "styles" do
    field :abvMax, :string
    field :abvMin, :string
    field :ibuMax, :string
    field :ibuMin, :string
    field :name, :string
    field :styleId, :integer
    field :category_id, :integer

    # belongs_to :category, WhatsHoppin.Beer.Style, foreign_key: :category_id

    timestamps()
  end

  @doc false
  def changeset(%Style{} = style, attrs) do
    style
    |> cast(attrs, [:styleId, :name, :ibuMin, :ibuMax, :abvMin, :abvMax])
    |> validate_required([:styleId, :name, :ibuMin, :ibuMax, :abvMin, :abvMax])
  end
end
