Code.load_file("gather_brewerydb_data.ex", "scripts")
alias WhatsHoppin.Beer.Category
alias WhatsHoppin.Beer.Style
alias WhatsHoppin.Locations.Brewery
alias WhatsHoppin.Repo

defmodule Populator do

	defp create_or_update_category(%{"id" => id, "name" => name}) do
		case cc = Repo.get_by(Category, category_id: id) do

			# create new entry
			nil  ->
				# 14
				Repo.insert!(%Category{name: name, category_id: id})

			# update entry
			_ ->
				cc = Ecto.Changeset.change cc, name: name, category_id: id
				case Repo.update(cc) do
					{:ok, struct} ->
						:ok
					{:error, changeset} ->
						IO.puts("ERROR when updating category with id #{id}")
						:error
				end
		end
	end

	# get all of the categories, and either add the entry if it doesnt yet exist,
	# or update the entry if it does exist already
	def update_categories() do
		BeerData.get_resource_all_pages("categories")
		|> Enum.map(fn c -> create_or_update_category(c) end)
	end

	defp create_or_update_style(s) do
		styleId = Map.get(s, "id")
		categoryId = Map.get(s, "categoryId")
		name = Map.get(s, "name")
		desc = Map.get(s, "description")

		# these fields are optional, which is really annoying since it
		# prevents easy pattern matching in the function signature
		ibuMin = Map.get(s, "ibuMin", "")
		ibuMax = Map.get(s, "ibuMax", "")
		abvMin = Map.get(s, "abvMin", "")
		abvMax = Map.get(s, "abvMax", "")

		case ss = Repo.get_by(Style, styleId: styleId) do
			
			# create it!
			nil ->
				Repo.insert!(%Style
					{styleId: styleId, category_id: categoryId,
					name: name, desc: desc, ibuMin: ibuMin, 
					ibuMax: ibuMax, abvMin: abvMin,abvMax: abvMax}
				)

			# update it!
			_ ->
				ss = Ecto.Changeset.change(ss, 
					styleId: styleId, category_id: categoryId,
					name: name, desc: desc, ibuMin: ibuMin, 
					ibuMax: ibuMax, abvMin: abvMin,abvMax: abvMax
				)
				case Repo.update(ss) do
					{:ok, struct} ->
						:ok
					{:error, changeset} ->
						IO.puts("ERROR when updating style with id #{styleId}")
						:error
				end
		end	
	end

	def update_styles() do
		BeerData.get_resource_all_pages("styles")
		|> Enum.map(fn s -> create_or_update_style(s) end)
	end

	# consume a brewery location
	defp create_or_update_brewery_location(l) do
		city = Map.get(l, "locality")
		state = Map.get(l, "region")
		location_type = Map.get(l, "locationTypeDisplay") || Map.get(l, "locationType")
		brewery = Map.get(l, "brewery")
		brewery_id = Map.get(brewery, "id")
		name = Map.get(brewery, "name")
		is_mass_owned = 
		case Map.get(brewery, "isMassOwned", "N") do
			"N" -> false
			_   -> true
		end
		website = Map.get(brewery, "website", "")
		established_date = Map.get(brewery, "established", "")

		case ll = Repo.get_by(Brewery, brewery_id: brewery_id) do
			
			# create it!
			nil ->
				Repo.insert!(%Brewery
					{city: city, state: state, location_type: location_type,
					brewery_id: brewery_id, name: name, is_mass_owned?: is_mass_owned,
					website: website, established_date: established_date}
				)

			# update it!
			_ ->
				ss = Ecto.Changeset.change(ll, 
					city: city, state: state, location_type: location_type,
					brewery_id: brewery_id, name: name, is_mass_owned?: is_mass_owned,
					website: website, established_date: established_date
				)
				case Repo.update(ll) do
					{:ok, struct} ->
						:ok
					{:error, changeset} ->
						IO.puts("ERROR when updating brewery with id #{brewery_id}")
						:error
				end
		end	
	end

	def update_breweries() do
		# BeerData.get_resource_all_pages("locations")
		BeerData.get_resource("locations", "p", 119)
		|> elem(0)
		|> Enum.filter(fn l -> Map.get(l, "region") != nil end)
		|> Enum.map(fn l -> create_or_update_brewery_location(l) end)
	end

end

HTTPoison.start
# Populator.update_categories()
# Populator.update_styles()

Populator.update_breweries()