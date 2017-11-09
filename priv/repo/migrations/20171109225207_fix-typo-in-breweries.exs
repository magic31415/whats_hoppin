defmodule :"Elixir.WhatsHoppin.Repo.Migrations.Fix-typo-in-breweries" do
  use Ecto.Migration

  def change do

  	alter table(:breweries) do
  		remove :established_data
  		add :established_date, :string
  	end

  end
end
