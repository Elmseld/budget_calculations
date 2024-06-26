import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :budget_calculations, BudgetCalculationsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "XpTblJF2q4MsFa9zT8uken4AvLBbBCE2eR7oVMRIj6oyADO6ITUvhYif4JSq3FRX",
  server: false

# In test we don't send emails.
config :budget_calculations, BudgetCalculations.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true
