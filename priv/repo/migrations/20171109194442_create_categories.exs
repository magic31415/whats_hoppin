defmodule WhatsHoppin.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :categoryId, :integer
      add :name, :string
      add :desc, :text

      timestamps()
    end

  end
end
