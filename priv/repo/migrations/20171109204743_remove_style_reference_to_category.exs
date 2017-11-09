defmodule WhatsHoppin.Repo.Migrations.RemoveStyleReferenceToCategory do
  use Ecto.Migration

  def change do

  	alter table(:styles) do
  		remove :category_id
  		add :category_id, :integer
  	end

  end
end
