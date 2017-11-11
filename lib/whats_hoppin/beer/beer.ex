defmodule WhatsHoppin.Beer do
  @moduledoc """
  The Beer context.
  """

  import Ecto.Query, warn: false
  alias WhatsHoppin.Repo

  alias WhatsHoppin.Beer.Category
  alias WhatsHoppin.Beer.Style

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  def get_styles_by_category(c) do
    IO.puts("Querying for styles with category id #{c.category_id}...")
    res = Repo.all(from s in Style, where: s.category_id == ^c.category_id)
    IO.puts("Number of styles: #{length res}")
    res
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  @doc """
  Returns the list of styles.

  ## Examples

      iex> list_styles()
      [%Style{}, ...]

  """
  def list_styles do
    Repo.all(Style)
  end

  @doc """
  Gets a single style.

  Raises `Ecto.NoResultsError` if the Style does not exist.

  ## Examples

      iex> get_style!(123)
      %Style{}

      iex> get_style!(456)
      ** (Ecto.NoResultsError)

  """
  def get_style!(id), do: Repo.get!(Style, id)

  @doc """
  Creates a style.

  ## Examples

      iex> create_style(%{field: value})
      {:ok, %Style{}}

      iex> create_style(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_style(attrs \\ %{}) do
    %Style{}
    |> Style.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a style.

  ## Examples

      iex> update_style(style, %{field: new_value})
      {:ok, %Style{}}

      iex> update_style(style, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_style(%Style{} = style, attrs) do
    style
    |> Style.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Style.

  ## Examples

      iex> delete_style(style)
      {:ok, %Style{}}

      iex> delete_style(style)
      {:error, %Ecto.Changeset{}}

  """
  def delete_style(%Style{} = style) do
    Repo.delete(style)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking style changes.

  ## Examples

      iex> change_style(style)
      %Ecto.Changeset{source: %Style{}}

  """
  def change_style(%Style{} = style) do
    Style.changeset(style, %{})
  end
end
