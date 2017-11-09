defmodule WhatsHoppin.Repo.Migrations.CreateStyles do
  use Ecto.Migration

  def change do
    create table(:styles) do
      add :styleId, :integer
      add :name, :string
      add :ibuMin, :string
      add :ibuMax, :string
      add :abvMin, :string
      add :abvMax, :string

      timestamps()
    end

  end
end
