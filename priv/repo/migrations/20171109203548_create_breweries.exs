defmodule WhatsHoppin.Repo.Migrations.CreateBreweries do
  use Ecto.Migration

  def change do
    create table(:breweries) do
      add :name, :string
      add :website, :string
      add :city, :string
      add :state, :string
      add :established_data, :integer
      add :is_mass_owned?, :boolean, default: false
      add :location_type, :string
      add :brewery_id, :string

      timestamps()
    end

  end
end
