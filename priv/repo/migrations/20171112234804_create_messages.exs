defmodule WhatsHoppin.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :brewery_id, references(:breweries, on_delete: :nothing), null: false, default: -1
      add :style_id, references(:styles, on_delete: :nothing), null: false, default: -1

      timestamps()
    end

    create index(:messages, [:user_id])
    create index(:messages, [:brewery_id])
    create index(:messages, [:style_id])
  end
end
