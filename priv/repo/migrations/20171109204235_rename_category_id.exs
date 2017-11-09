defmodule WhatsHoppin.Repo.Migrations.RenameCategoryId do
  use Ecto.Migration

  def change do

  	alter table(:categories) do
      remove :categoryId#, references(:users, on_delete: :delete_all)
      add :category_id, :integer #, references(:users, on_delete: :delete_all)
    end

  end
end
