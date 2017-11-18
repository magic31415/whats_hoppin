defmodule WhatsHoppin.Locations.Brewery do
  use Ecto.Schema
  import Ecto.Changeset
  alias WhatsHoppin.Locations.Brewery


  schema "breweries" do
    field :brewery_id, :string
    field :city, :string
    field :established_date, :string
    field :is_mass_owned?, :boolean, default: false
    field :location_type, :string
    field :name, :string
    field :state, :string
    field :website, :string

    field :desc, :string

    timestamps()
  end

  @doc false
  def changeset(%Brewery{} = brewery, attrs) do
    brewery
    |> cast(attrs, [:name, :website, :city, :state, :established_date, :is_mass_owned?, :location_type, :brewery_id, :desc])
    |> validate_required([:name, :website, :city, :state, :established_date, :is_mass_owned?, :location_type, :brewery_id])
  end
end
