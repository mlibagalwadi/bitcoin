defmodule BitcoinDashboard.Repo do
  use Ecto.Repo,
    otp_app: :bitcoinDashboard,
    adapter: Ecto.Adapters.Postgres
end
