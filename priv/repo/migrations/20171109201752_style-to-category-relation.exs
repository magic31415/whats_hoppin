defmodule :"Elixir.WhatsHoppin.Repo.Migrations.Style-to-category-relation" do
  use Ecto.Migration

  def change do

  	alter table(:styles) do
  		add :category_id, references(:categories, on_delete: :delete_all), null: false
  	end

  end
end
