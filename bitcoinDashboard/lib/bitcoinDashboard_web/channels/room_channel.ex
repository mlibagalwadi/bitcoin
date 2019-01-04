defmodule BitcoinDashboardWeb.RoomChannel do
  use BitcoinDashboardWeb, :channel

  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("geAllWallets", payload, socket) do
    broadcast socket, "geAllWallets", payload
    wallets = Bitcoin.getWallets()

    IO.inspect wallets

    push socket, "geAllWallets", %{wallets: wallets}
    {:noreply, socket}
  end

  def handle_in("performMining", payload, socket) do
    broadcast socket, "performMining", payload
    wallets = Bitcoin.performMining()

    IO.inspect wallets

    push socket, "performMining", %{wallets: wallets}
    {:noreply, socket}
  end

  def handle_in("viewWallets", payload, socket) do
    broadcast socket, "viewWallets", payload
    wallets = Bitcoin.viewWallets()

    IO.inspect wallets

    push socket, "viewWallets", %{wallets: wallets}
    {:noreply, socket}
  end


  def handle_in("generateWalletsForTransaction", payload, socket) do
    broadcast socket, "generateWalletsForTransaction", payload
    wallets = Bitcoin.viewWallets()

    IO.inspect wallets

    push socket, "generateWalletsForTransaction", %{wallets: wallets}
    {:noreply, socket}
  end

  def handle_in("generateTransaction", payload, socket) do
    IO.puts "fromWalletfromWalletfromWalletfromWalletfromWallet"
    IO.inspect(payload)
    fromWallet = payload["fromWallet"]
    toWallet = payload["toWallet"]
    amount = payload["amount"]

    wallets = Transaction.generateTransaction(fromWallet, toWallet, amount)
    IO.inspect wallets
    push socket, "generateTransaction", %{wallets: wallets}
    {:noreply, socket}
  end

  def handle_in("viewBlockchain", payload, socket) do
    IO.puts "viewBlockchain"
    IO.inspect(payload)

    blockchain = Block.getBlockchain()
    IO.inspect blockchain
    push socket, "viewBlockchain", %{blockchain: blockchain}
    {:noreply, socket}
  end

  def handle_in("viewTransactions", payload, socket) do
    IO.puts "viewTransactions"
    IO.inspect(payload)

    confirmedTransactions = Transaction.getConfirmedTransactions()
    unconfirmedTransactions = Transaction.getUnconfirmedTransactions()
    IO.inspect confirmedTransactions
    IO.puts "unconfirmed"
    IO.inspect unconfirmedTransactions
    push socket, "viewTransactions", %{confirmedTransactions: confirmedTransactions, unconfirmedTransactions: unconfirmedTransactions}
    {:noreply, socket}
  end

  def handle_in("viewCharts", payload, socket) do
    broadcast socket, "viewCharts", payload
    wallets = Bitcoin.viewWallets()

    IO.inspect wallets

    push socket, "viewCharts", %{wallets: wallets}
    {:noreply, socket}
  end



  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
