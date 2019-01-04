defmodule BitcoinDashboardWeb.PageController do
  use BitcoinDashboardWeb, :controller

  def index(conn, _params) do
    # Bitcoin.start()

    conn1 = put_session(conn, :table, "new stuff we just set in the session")
    message = get_session(conn, :table)
    IO.puts message

    render(conn, "index.html")
  end

  def toWallets(conn, _params) do
    redirect(conn, to: "/wallets")
  end
end
