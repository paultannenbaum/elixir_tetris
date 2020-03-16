use Mix.Config

config :tetris, TetrisWeb.Endpoint,
  url: [System.get_env("WEB_HOST")],
  http: [port: {:system, "PORT"}],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :tetris, Tetris.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  database: "",
  ssl: true,
  pool_size: 1

# Do not print debug messages in production
config :logger, level: :info
