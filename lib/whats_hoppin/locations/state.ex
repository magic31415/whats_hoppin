defmodule WhatsHoppin.Locations.State do
  use Ecto.Schema
  import Ecto.Changeset
  alias WhatsHoppin.Locations.State


  schema "states" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%State{} = state, attrs) do
    state
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
