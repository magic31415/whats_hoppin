defmodule WhatsHoppin.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all) #, null: false
      add :forum_id, :string, null: false

      timestamps()
    end

    create index(:messages, [:user_id])
  end
end
