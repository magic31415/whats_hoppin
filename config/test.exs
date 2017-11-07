use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :whats_hoppin, WhatsHoppinWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :whats_hoppin, WhatsHoppin.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "whats_hoppin",
  password: "Ephohl3Uco",
  database: "whats_hoppin_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
