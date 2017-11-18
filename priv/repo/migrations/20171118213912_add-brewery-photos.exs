defmodule :"Elixir.WhatsHoppin.Repo.Migrations.Add-brewery-photos" do
  use Ecto.Migration

  def change do

  	alter table(:breweries) do
  		add :icon_url, :string
  		add :medium_pic_url, :string
  		add :large_pic_url, :string
  	end

  end
end
