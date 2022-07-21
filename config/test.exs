import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pokerplanning, PokerplanningWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Nfdw2y+3SZTadx98n6dYXCxOHmqA4SA2F6atqZZu3n1Zn4qN8s7IqnlZpNb7pApr",
  server: false

# In test we don't send emails.
config :pokerplanning, Pokerplanning.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
