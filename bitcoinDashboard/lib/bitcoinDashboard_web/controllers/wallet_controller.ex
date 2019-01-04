defmodule BitcoinDashboardWeb.WalletController do
  use BitcoinDashboardWeb, :controller

  def index(conn, _params) do
    networkId = Network.generateNetwork()
    numOfWallets = 10
    numOfTransactions = 10
    transactionId = Transaction.genesisTransaction()
		# IO.puts transactionId
		# count = :ets.update_counter(:table, "globalCount", {3,1})
		# IO.inspect count
		blockId= Block.startBlock()
		genesisBlockId = Block.genesisBlock(transactionId)
		IO.puts "Genesis block created..."
		blockchain = [genesisBlockId]
		IO.puts "Blockchain created with Genesis block..."
		Network.updateNetworkBlockchain(networkId, blockchain)


		# Create wallets


		walletPublicKeyList = Enum.map(1..numOfWallets, fn(x) ->
			Wallet.generateWallet(x, blockchain, networkId)
		end)

		allWalletIds = Enum.map(0..numOfWallets-1, fn(x) ->
			Enum.fetch!(Enum.fetch!(walletPublicKeyList, x), 0)
		end)
		# walletsMap = Network.getNetworkState()
		allWallets =  Enum.map(0..numOfWallets-1, fn(walletId) ->
			{name, publicKey, privateKey, allPublicKeys, uTransactions, allTransactions, blockchain, target, networkId, walletBalance} = Wallet.getWalletState(Enum.fetch!(allWalletIds, walletId))
			%{name: name, publicKey: publicKey, privateKey: privateKey, allPublicKeys: allPublicKeys, uTransactions: uTransactions, allTransactions: allTransactions, blockchain: blockchain, target: target, networkId: networkId, walletBalance: walletBalance}
		end)

    # IO.inspect allWalletIds


    # IO.inspect networkId
		render(conn, "walletList.html", wallets: allWallets)

	end


	def create(conn, _params) do
		render(conn, "create.html")
	end


end


