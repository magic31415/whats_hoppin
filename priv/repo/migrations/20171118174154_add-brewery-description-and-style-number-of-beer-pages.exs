defmodule :"Elixir.WhatsHoppin.Repo.Migrations.Add-brewery-description-and-style-number-of-beer-pages" do
  use Ecto.Migration

  def change do

  	alter table(:breweries) do
  		add :desc, :text
  	end

  	alter table(:styles) do
  		add :number_beer_pages, :integer
  	end

  end
end
