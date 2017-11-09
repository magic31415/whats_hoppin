defmodule :"Elixir.WhatsHoppin.Repo.Migrations.Add-description-to-style" do
  use Ecto.Migration

  def change do

  	alter table(:styles) do
  		add :desc, :text
  	end

  end
end
