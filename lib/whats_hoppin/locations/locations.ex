defmodule WhatsHoppin.Locations do
  @moduledoc """
  The Locations context.
  """

  import Ecto.Query, warn: false
  alias WhatsHoppin.Repo

  alias WhatsHoppin.Locations.Brewery


  def get_brewery_image_medium(%{medium_pic_url: med, large_pic_url: lrg}) do
    case med do
      "" -> lrg
      _  -> med
    end
  end

  def format_brewery_location(%{city: city, state: state}) do
    case city do
      "" -> "(#{state})"
      _  -> "(#{city}, #{state})"
    end
  end

  def get_random_brewery() do
    breweries = list_breweries()
    breweries
    |> length
    |> :rand.uniform
    |> (fn(num) -> Enum.at(breweries, num) end).()
  end

  @doc """
  Returns the list of breweries.

  ## Examples

      iex> list_breweries()
      [%Brewery{}, ...]

  """
  def list_breweries do
    Repo.all(Brewery)
  end

  @doc """
  Gets a single brewery.

  Raises `Ecto.NoResultsError` if the Brewery does not exist.

  ## Examples

      iex> get_brewery!(123)
      %Brewery{}

      iex> get_brewery!(456)
      ** (Ecto.NoResultsError)

  """
  def get_brewery!(id), do: Repo.get!(Brewery, id)


  def get_breweries_by_state(state) do
    Repo.all(from b in Brewery, where: b.state == ^state)
  end

  @doc """
  Creates a brewery.

  ## Examples

      iex> create_brewery(%{field: value})
      {:ok, %Brewery{}}

      iex> create_brewery(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_brewery(attrs \\ %{}) do
    %Brewery{}
    |> Brewery.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a brewery.

  ## Examples

      iex> update_brewery(brewery, %{field: new_value})
      {:ok, %Brewery{}}

      iex> update_brewery(brewery, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_brewery(%Brewery{} = brewery, attrs) do
    brewery
    |> Brewery.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Brewery.

  ## Examples

      iex> delete_brewery(brewery)
      {:ok, %Brewery{}}

      iex> delete_brewery(brewery)
      {:error, %Ecto.Changeset{}}

  """
  def delete_brewery(%Brewery{} = brewery) do
    Repo.delete(brewery)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking brewery changes.

  ## Examples

      iex> change_brewery(brewery)
      %Ecto.Changeset{source: %Brewery{}}

  """
  def change_brewery(%Brewery{} = brewery) do
    Brewery.changeset(brewery, %{})
  end

  alias WhatsHoppin.Locations.State

  @doc """
  Returns the list of states.

  ## Examples

      iex> list_states()
      [%State{}, ...]

  """
  def list_states do
    Repo.all(State)
  end

  @doc """
  Gets a single state.

  Raises `Ecto.NoResultsError` if the State does not exist.

  ## Examples

      iex> get_state!(123)
      %State{}

      iex> get_state!(456)
      ** (Ecto.NoResultsError)

  """
  def get_state!(id), do: Repo.get!(State, id)

  @doc """
  Creates a state.

  ## Examples

      iex> create_state(%{field: value})
      {:ok, %State{}}

      iex> create_state(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_state(attrs \\ %{}) do
    %State{}
    |> State.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a state.

  ## Examples

      iex> update_state(state, %{field: new_value})
      {:ok, %State{}}

      iex> update_state(state, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_state(%State{} = state, attrs) do
    state
    |> State.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a State.

  ## Examples

      iex> delete_state(state)
      {:ok, %State{}}

      iex> delete_state(state)
      {:error, %Ecto.Changeset{}}

  """
  def delete_state(%State{} = state) do
    Repo.delete(state)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking state changes.

  ## Examples

      iex> change_state(state)
      %Ecto.Changeset{source: %State{}}

  """
  def change_state(%State{} = state) do
    State.changeset(state, %{})
  end
end
