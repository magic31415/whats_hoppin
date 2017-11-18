defmodule WhatsHoppin.Beer do
  @moduledoc """
  The Beer context.
  """

  import Ecto.Query, warn: false
  alias WhatsHoppin.Repo

  alias WhatsHoppin.Beer.Category
  alias WhatsHoppin.Beer.Style


  # taken from Nat Tuck's lecture notes about asynchronous operations using Task
  defp parallel_map(xs, op) do
    tasks = Enum.map xs, fn x ->
      Task.async(fn -> op.(x) end)
    end
    a = Enum.map tasks, fn t ->
      Task.await(t, 10000)
    end
    List.flatten(a)
  end

  def get_beers_with_style(styleId, page_num) do
    path("beers", "styleId", styleId)
    |> add_attr_to_path("p", page_num)
    |> get_path
    |> elem(0)
  end

  def get_beers_in_style_parallel(%{styleId: styleId, number_beer_pages: num_pages}) do
    # num_pages = 
    # if num_pages >= 10 do 10 else num_pages end

    parallel_map 1..num_pages, fn page_num ->
      get_beers_with_style(styleId, page_num)
    end
  end

  ################################################
  # Stuff for formatting HTML data
  ################################################

  def format_beer_description(beer) do
    failStr = "No description available."
    desc = 
    case d = Map.get(beer, "description") do
      nil -> "No description available."
      _   -> d
    end

    abvStr = 
    case abv = Map.get(beer, "abv") do
      nil -> ""
      _   -> ["ABV: ", abv] |> Enum.join("")
    end

    if abvStr == "" do
      desc
    else
      "#{desc}\n\n#{abvStr}%"
    end
  end


  ################################################
  # stuff for gathering data from the BreweryDB API
  ################################################


  defp base_path() do
    "http://api.brewerydb.com/v2"
  end

  defp api_key() do
    Application.get_env(:whats_hoppin, :api_key)
  end

  def states() do
    Application.get_env(:whats_hoppin, :states)
  end

  def path(resource, key, value) do
    "#{base_path()}/#{resource}/#{api_key()}&#{key}=#{to_string((value))}"
  end

  def path(resource) do
    "#{base_path()}/#{resource}/#{api_key()}"
  end

  # return a a SINGLE PAGE (max 50) of beers made by a specific brewery
  def get_beers_within_brewery(brewery_id) do
    "#{base_path()}/brewery/#{brewery_id}/beers/#{api_key()}"
    |> get_path
    |> elem(0)
  end

  @doc """
  Do a GET request to the specified BreweryDB resource (eg. "beer", "brewery", "breweries", etc)
  """
  @spec get_resource(String) :: {Map, Integer}
  def get_resource(brewery_db_resource) do
    path(brewery_db_resource)
    |> get_path
  end

  @doc """
  Same as above, but get every page of associated content
  """
  @spec get_resource(String, String, String) :: {Map, Integer}
  def get_resource_all_pages(brewery_db_resource) do
    api_path = path(brewery_db_resource)
    api_path
    |> get_path
    |> maybe_get_all_pages(api_path)
  end

  @doc """
  Do a GET request to the specified path, adding the key/value pair after the
  api_key() with &key=value
  """
  @spec get_resource(String, String, String) :: {Map, Integer}
  def get_resource(brewery_db_resource, key, value) do
    path(brewery_db_resource, key, value)
    |> get_path
  end

  @doc """
  Same as above, but get every page of associated content
  """
  @spec get_resource(String, String, String) :: {Map, Integer}
  def get_resource_all_pages(brewery_db_resource, key, value) do
    api_path = path(brewery_db_resource, key, value)
    api_path
    |> get_path
    |> maybe_get_all_pages(api_path)
  end

  @doc """
  Using the passed-in string as the full path, perform a GET request and return
  the result as a tuple with the following form

  """
  @spec get_path(String) :: {Map, Integer}
  def get_path(full_path) do
    full_path
    |> HTTPoison.get!
    # result of Poison.decode/1 is (ex:) {:ok, %{"data": [], "numberOfPages": X}}
    |> (fn(resp) -> Poison.decode(resp.body) end).()
    |> elem(1)
    |> 
    (fn(j) -> 
      { Map.get(j, "data"), Map.get(j, "numberOfPages", 1) }
    end).()
  end


  @doc """
  Add a key value pair to the end of the path.
  """
  def add_attr_to_path(path, key, value) do
    "#{path}&#{key}=#{to_string(value)}"
  end

  # Base case for get_all_pages_helper
  defp get_all_pages_helper(acc, path, 1) do
    new_data = 
    add_attr_to_path(path, "p", 1)
    |> get_path
    |> elem(0)
    acc ++ new_data
  end

  # Get all pages for a specific resource, using an accumulator to return a single list of
  # objects found in pages [@page_num, 1]
  defp get_all_pages_helper(acc, path, page_num) do
    new_data = 
    add_attr_to_path(path, "p", page_num)
    |> get_path
    |> elem(0)
    acc = acc ++ new_data
    get_all_pages_helper(acc, path, page_num - 1)
  end

  # Get all pages and wrap into a single list.
  defp get_all_pages(path, num_pages) do
    get_all_pages_helper([], path, num_pages)
  end

  # Consume the result of get_resource or get_path, and get all the pages assocaited
  # with that result, or just return the result if there's only one page.
  # Use the "api_path" to complete subsequent requests, if necessary.
  defp maybe_get_all_pages(req_result, api_path) do
    case num_pages = elem(req_result, 1) do
      1 -> elem(req_result, 0)
      _ -> get_all_pages(api_path, num_pages)
    end
  end

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

  # Helpers for generating ABV and IBU info text 
  def gen_text(min, max, units) do
    if min != "" || max != "" do
      dash = if min != "" && max != "" do " - " else "" end
      min <> dash <> max <> units
    else
      ""
    end
  end

  def gen_abv_text(%Style{} = style) do
    gen_text(style.abvMin, style.abvMax, "% ABV")
  end

  def gen_ibu_text(%Style{} = style) do
    gen_text(style.ibuMin, style.ibuMax, " IBUs")
  end
end
