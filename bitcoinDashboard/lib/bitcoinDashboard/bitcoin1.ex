import Commons
import Network
import GenerateRandomString
import Wallet
import Block
import Transaction
import Network

defmodule Bitcoin do
	@moduledoc """
	Documentation for Bitcoin.
	Functionalities implemented:
		- Create a Network to maintain Wallets, Transactions, and the Blockchain.
		- Generate <numOfWallets> Wallets, who start Mining asynchronously.
		- Mining involves performing Proof Of Work, creating a Coinbase Transaction, adding it to the new Block to be added to the Blockchain in case of successful Mining.
		- Transfer BTC to and from random Wallets by creating Transactions and updating the respective Wallet states.
		- Update and validate the Blockchain.
	"""

	@doc """
	Main
	The System can be configured using two input parameters:
		numOfWallets -  the number of wallets in the Bitcoin network
		numOfTransactions - the number of random Transactions to be made between wallets.
	"""

	def start do
		networkId = generateNetwork()
		table = :ets.new(:table, [:named_table,:public])
    :ets.insert(table, {"networkId",networkId})
	end

	def getWallets do
		main()
	end

	def main() do
		start()
		IO.puts ""
		IO.puts ""
		IO.puts ""
		[numOfWallets,numOfTransactions] = ["20","10"]
		{numOfWallets, _} = Integer.parse(numOfWallets)
		{numOfTransactions, _} = Integer.parse(numOfTransactions)
		networkId = getNetworkId()
		IO.inspect("NETWORKNETWORK")
		IO.inspect networkId
		# table = :ets.new(:table, [:named_table,:public])
    # :ets.insert(table, {"networkId",networkId})
		IO.puts "Network created..."

		transactionId = genesisTransaction()
		# IO.puts transactionId
		IO.puts "Genesis transaction created..."


		# blockId=startBlock()
		genesisBlockId = genesisBlock(transactionId)
		IO.puts "Genesis block created..."
		blockchain = [genesisBlockId]
		IO.puts "Blockchain created with Genesis block..."
		updateNetworkBlockchain(networkId, blockchain)


		# Create wallets

		walletPublicKeyList = Enum.map(1..numOfWallets, fn(x) ->
			generateWallet(x, blockchain, networkId)
		end)

		allWalletIds = Enum.map(0..numOfWallets-1, fn(x) ->
			Enum.fetch!(Enum.fetch!(walletPublicKeyList, x), 0)
		end)

		allPublicKeys = Enum.map(0..numOfWallets-1, fn(x) ->
			Enum.fetch!(Enum.fetch!(walletPublicKeyList, x), 1)
		end)

		IO.puts "allPublicKeys allPublicKeys"
		IO.inspect allPublicKeys

		updateNetworkWalletIdMaps(networkId,walletPublicKeyList)
		# allWalletIds
		# %{name: "Fatema"}
		# "Fatema"

		Enum.each(0..numOfWallets-1, fn(x) ->
			wId =  Enum.fetch!(Enum.fetch!(walletPublicKeyList, x), 0)
			updateWalletPublicKeys(wId, allPublicKeys)
		end)

		# allWallets =  Enum.map(0..numOfWallets-1, fn(walletId) ->
		# 	{name, publicKey, privateKey, allPublicKeys, uTransactions, allTransactions, blockchain, target, networkId, walletBalance} =getWalletState(Enum.fetch!(allWalletIds, walletId))
		# 	%{name: name, publicKey: publicKey, privateKey: privateKey, walletBalance: walletBalance}
		# end)

		# allWallets


		# Enum.each(0..numOfWallets-1, fn(x) ->
		# 	wId =  Enum.fetch!(Enum.fetch!(walletPublicKeyList, x), 0)
		# 	updateWalletPublicKeys(wId, allPublicKeys)
		# 	# IO.inspect :calendar.local_time()
		# 	Task.start(Bitcoin,:mining,[wId])
		# end)

		# IO.puts("\nMining in progress...\n")
		# :timer.sleep(1000*numOfWallets)
		# Enum.each(1..numOfTransactions,fn(x)->
		# 	[sender,receiver] = Enum.take_random(allWalletIds,2)
		# 	amountToSend = 7.5
		# 	IO.puts "Transaction #{x} :"
		# 	createWalletToWalletTx(sender,receiver,amountToSend)
		# 	IO.puts "All wallet balances after transaction #{x}"
		# 	IO.puts("-----------------------------")
		# 	IO.puts("| WALLET ID     |  BALANCE  |")
		# 	Enum.each(allWalletIds, fn(y)->
		# 		getWalletBalance(y)
		# 	end)
		# 	IO.puts("-----------------------------")

		# end)
		# :timer.sleep(1)

	end

	def viewWallets() do

		networkId = getNetworkId()

		{_,_,walletPublicKeyList,_} = getNetworkState(networkId)

		numOfWallets = 20
		allWalletIds = Enum.map(walletPublicKeyList, fn(x) ->
			wId =  Enum.fetch!(x, 0)
			wId
		end)

		allWallets =  Enum.map(0..numOfWallets-1, fn(walletId) ->
			{name, publicKey, privateKey, allPublicKeys, uTransactions, allTransactions, blockchain, target, networkId, walletBalance} =getWalletState(Enum.fetch!(allWalletIds, walletId))
			%{name: name, publicKey: publicKey, privateKey: privateKey, walletBalance: walletBalance}
		end)

		allWallets
	end


	def performMining() do

			networkId = getNetworkId()
			numOfWallets = 20
			# numOfWalletsToMine = Enum.take_random(1..numOfWallets, 4)
			# IO.inspect
			{_,_,walletPublicKeyList,_} = getNetworkState(networkId)
			numOfWalletsToMine = Enum.take_random(walletPublicKeyList, 3)
			# IO.inspect walletPublicKeyList
			# walletPublicKeyList = Enum.fetch!(walletPublicKeyList,0)
			IO.inspect walletPublicKeyList

			minedWalletsList = Enum.map(numOfWalletsToMine, fn(x) ->
					IO.puts "xxxxxxxxxxxx"
					# IO.inspect Enum.fetch!(walletPublicKeyList, x)
					wId = Enum.fetch!(x, 0)
					IO.inspect wId
					# IO.inspect :calendar.local_time()
					Task.start(Bitcoin,:mining,[wId])
					wId
				end)

			# Enum.each(0..numOfWallets-1, fn(x) ->
			# 	IO.puts "xxxxxxxxxxxx"
			# 	# IO.inspect Enum.fetch!(walletPublicKeyList, x)
			# 	wId = Enum.fetch!(Enum.fetch!(walletPublicKeyList, x), 0)

			# 	# IO.inspect :calendar.local_time()
			# 	Task.start(Bitcoin,:mining,[wId])
			# 	wId
			# end)
			:timer.sleep(2000)

			allWallets =  Enum.map(minedWalletsList, fn(walletId) ->
				{name, publicKey, privateKey, allPublicKeys, uTransactions, allTransactions, blockchain, target, networkId, walletBalance} =getWalletState(walletId)
				%{name: name, publicKey: publicKey, privateKey: privateKey, walletBalance: walletBalance}
			end)

			allWallets




		# IO.puts("\nMining in progress...\n")
		# :timer.sleep(1000*numOfWallets)
		# Enum.each(1..numOfTransactions,fn(x)->
		# 	[sender,receiver] = Enum.take_random(allWalletIds,2)
		# 	amountToSend = 7.5
		# 	IO.puts "Transaction #{x} :"
		# 	createWalletToWalletTx(sender,receiver,amountToSend)
		# 	IO.puts "All wallet balances after transaction #{x}"
		# 	IO.puts("-----------------------------")
		# 	IO.puts("| WALLET ID     |  BALANCE  |")
		# 	Enum.each(allWalletIds, fn(y)->
		# 		getWalletBalance(y)
		# 	end)
		# 	IO.puts("-----------------------------")

		# end)
		# :timer.sleep(1)

	end

	################################################
	# Basic blockchain functions
	################################################

	@doc """
	Block is validated before adding it to the blockchain by the wallet by checking the following
		- The Index of the new Block = 1 + Index of the last block of Blockchain
		- Hash of the last block of Blockchain  == PrevHash of the new Block
		- Recalculate the Hash of the new block and check if it matches.

	"""
	def isBlockValid(newBlockId, oldBlockId) do
		{oldBlockIndex, oldBlockTime, oldBlockHash, oldBlockPrevHash, oldBlocktransactions, oldBlockLength, oldBlockMerkleRoot} = getBlockState(oldBlockId)
		{newBlockIndex, newBlockTime,  newBlockHash, newBlockPrevHash, newBlocktransactions, newBlockLength, newBlockMerkleRoot} = getBlockState(newBlockId)
		true
		if oldBlockIndex+1 != newBlockIndex do
			IO.puts "index"
		        false
		else
				if oldBlockHash != newBlockPrevHash do
					IO.puts "prevHash"
		        	false
				else
					if calculateHash(newBlockId) != newBlockHash do
						IO.puts "newHash"
		   		     	false
					else
						true
					end
				end
		end

	end


	@doc """
	Mining

		# Performs Bitcoin mining for the walletId sent in the input.
		# Gets the latest blockchain from the network and updates the current version of the blockchain maintained by the wallet.
		# Using the hash of the last block on the blockchain, a random nonce value is appended to the hash and this new string is hashed again.
		# If we get a hash with the required target leading 0s, we have managed to mine a bitcoin successfully.
		# In this case, we create a coinbase transaction, add it to a block and add this block to the blockchain and the new blockchain is updated in the network.
		# If the hash does not contain the required target leading 0s, we call the same function recursively again for the same walletId.
	"""
	def mining(walletId) do
		{name, publicKey, privateKey, allPublicKeys, uTransactions, allTransactions, blockchain, target, networkId, walletBalance} = getWalletState(walletId)

		networkBlockchain = getNetworkBlockchain(networkId)
		lastBlockId = Enum.fetch!(blockchain, length(blockchain)-1)
		blockchain = updateWalletBlockchain(walletId, networkBlockchain)


		{blockIndex, blockTime, blockHash, blockPrevHash, blockTransactions, blockLength, blockMerkleRoot} = getBlockState(lastBlockId)

		# get random string with length <difficulty>
		nonce = randomizer(10)
		newValueHash = blockHash <> nonce
		newHash = generateHash(newValueHash)
		if (String.slice(newHash, 0..target) == String.duplicate("0", target+1)) do
			# create a new block
			# create a Coinbase transaction
			# inputHash, inputSignature, inputPublicKey
			coinBaseTransactionInputs = [
				[
					String.duplicate("0", 64),
					"",
					generateHash("")
				]
			]
			blockReward = 12.5
			coinBaseTransactionOutputs = [
				[
					blockReward,
					publicKey
				]
			]
			coinBaseTransactionId = generateTransaction(coinBaseTransactionInputs, coinBaseTransactionOutputs)



			transactions = getNetworkConfirmedTransactionPool(networkId)
			# IO.inspect transactions

			blockId = generateBlock(lastBlockId, [coinBaseTransactionId]  ++ transactions)
			# Add block to the blockchain
			newBlockChain = blockchain ++ [blockId]
			removeNetworkConfirmedTransactionPool(networkId, transactions)

			# IO.inspect isBlockValid(blockId,lastBlockId)

			if isBlockValid(blockId,lastBlockId) do

				IO.puts "Nonce: #{nonce}"
				updateNetworkBlockchain(networkId,newBlockChain)
				updateWalletBlockchain(walletId, newBlockChain)

				# create a new transaction for bitcoin reward
				# add it to transaction pool

				updateWalletUnusedTransactions(walletId, coinBaseTransactionId,blockReward)
				{name, publicKey, privateKey, allPublicKeys, uTransactions, allTransactions, blockchain, target, networkId, walletBalance} = getWalletState(walletId)

				IO.puts "Bitcoin mined successfully!"

				getWalletBalance(walletId)
			else
				mining(walletId)
			end

		else
			mining(walletId)
		end


	end

	# def mining(name, publicKey, privateKey, allPublicKeys, uTransactions, allTransactions, blockchain, target, blockIndex, blockTime, blockHash, blockPrevHash, blockTransactions, blockLength, blockMerkleRoot)


end

# Bitcoin.start()
