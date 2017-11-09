# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :whats_hoppin,
  ecto_repos: [WhatsHoppin.Repo]

# Configures the endpoint
config :whats_hoppin, WhatsHoppinWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Yxe5Ke1Su6L1oHYj8yWm9DYh+qMl4oy+maPaWORnysRQm7MsXZ2QPFso4+M1TWub",
  render_errors: [view: WhatsHoppinWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WhatsHoppin.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
import_config "secret.exs"
