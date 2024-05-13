# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :budget_calculations,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :budget_calculations, BudgetCalculationsWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: BudgetCalculationsWeb.ErrorHTML, json: BudgetCalculationsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: BudgetCalculations.PubSub,
  live_view: [signing_salt: "Vcer3Duc"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :budget_calculations, BudgetCalculations.Mailer, adapter: Swoosh.Adapters.Local

config :budget_calculations,
  countries: %{
    "se" => %{
      income_threshold_for_state_tax: 615_300,
      income_taxes_rate: 0.3,
      service_pension_max: 573_000
    },
    # TODO - update with real number
    "us" => %{
      income_threshold_for_state_tax: 600_000,
      income_taxes_rate: 0.30,
      service_pension_max: 120_000
    },
    "de" => %{
      income_threshold_for_state_tax: 400_000,
      income_taxes_rate: 0.20,
      service_pension_max: 80000
    }
  }

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  budget_calculations: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  budget_calculations: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
