# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nordref,
  ecto_repos: [Nordref.Repo]

# Configures the endpoint
config :nordref, NordrefWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "a6phcGyjlaEr1FtJRsX325eF0aj/hFTgUJt+NL4ZC46J8W72hqm5AGS6k+pqsky5",
  render_errors: [view: NordrefWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nordref.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
