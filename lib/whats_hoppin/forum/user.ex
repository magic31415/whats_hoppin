defmodule WhatsHoppin.Forum.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias WhatsHoppin.Forum.User


  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :pw_last_try, :utc_datetime
    field :pw_tries, :integer
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password_hash, :pw_tries, :pw_last_try])
    |> validate_required([:username, :email, :password_hash, :pw_tries, :pw_last_try])
  end
end
