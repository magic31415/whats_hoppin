defmodule WhatsHoppin.Forum.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias WhatsHoppin.Forum
  alias WhatsHoppin.Forum.User

  schema "users" do
    field :email, :string
    field :username, :string
    has_many :messages, Forum.Message

    field :password_hash, :string
    field :pw_last_try, :utc_datetime
    field :pw_tries, :integer
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :password_confirmation])
    |> validate_email(:email)
    |> validate_username(:username)
    |> validate_confirmation(:password)
    |> validate_password(:password)
    |> put_pass_hash()
    |> validate_required([:username, :email, :password_hash])
  end

  def validate_username(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, username ->
      case valid_username?(username) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  def valid_username?(username) do
    cond do
      String.length(username) > 20 ->
        {:error, "Username is too long"}
      Forum.get_user_by_username(username) != nil ->
        {:error, "Username is already in use"}
      true ->
        {:ok, username}
    end
  end

  def validate_email(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, email ->
      case valid_email?(email) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  def valid_email?(email) do
    # Regex from https://gist.github.com/mgamini/4f3a8bc55bdcc96be2c6
    cond do
      String.length(email) > 100 ->
        {:error, "Email address is too long"}
      not Regex.match?(~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, email) ->
        {:error, "Invalid email address"}
      Forum.get_user_by_email(email) != nil ->
        {:error, "Email address already in use"}
      true ->
        {:ok, email}
    end
  end

  # Password validation
  # From Comeonin docs and lecture notes
  def validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case valid_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  def put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end
  def put_pass_hash(changeset), do: changeset

  def valid_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end
  def valid_password?(_), do: {:error, "The password is too short"}

  def get_and_auth_user(username, password) do
    user = Forum.get_user_by_username(username)
    case user != nil && throttle_attempts(user) && Comeonin.Argon2.check_pass(user, password) do
      {:ok, user} -> user
      _else       -> nil
    end
  end

  def update_tries(throttle, prev) do
    if throttle do
      prev + 1
    else
      1
    end
  end

  def throttle_attempts(user) do
    y2k = DateTime.from_naive!(~N[2000-01-01 00:00:00], "Etc/UTC")
    prv = DateTime.to_unix(user.pw_last_try || y2k)
    now = DateTime.to_unix(DateTime.utc_now())
    thr = (now - prv) < 3600

    if (thr && user.pw_tries > 5) do
      nil
    else
      changes = %{
          pw_tries: update_tries(thr, user.pw_tries),
          pw_last_try: DateTime.utc_now(),
      }
      IO.inspect(user)
      {:ok, user} = Ecto.Changeset.cast(user, changes, [:pw_tries, :pw_last_try])
      |> WhatsHoppin.Repo.update
      user
    end
  end
end
