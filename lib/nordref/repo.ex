defmodule Nordref.Repo do
  use Ecto.Repo,
    otp_app: :nordref,
    adapter: Ecto.Adapters.Postgres
end
