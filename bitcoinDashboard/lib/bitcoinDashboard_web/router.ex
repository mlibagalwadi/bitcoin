defmodule BitcoinDashboardWeb.Router do
  use BitcoinDashboardWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BitcoinDashboardWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/wallets", WalletController, :index
    get "/wallets/create", WalletController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", BitcoinDashboardWeb do
  #   pipe_through :api
  # end
end
