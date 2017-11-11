# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WhatsHoppin.Repo.insert!(%WhatsHoppin.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias WhatsHoppin.Locations.State
alias WhatsHoppin.Repo

Repo.delete_all(State)
Application.get_env(:whats_hoppin, :states)
|> Enum.map(fn (s) ->
	Repo.insert!(%State{name: s}) 
end)