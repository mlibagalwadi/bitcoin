defmodule BitcoinTest do
  use ExUnit.Case
  doctest Bitcoin

  setup do
    
    IO.puts "Testing Bitcoin..."	
    networkId = Network.generateNetwork()
    
		transactionId = Transaction.genesisTransaction()
		genesisBlockId = Block.genesisBlock(transactionId)
		
		blockchain = [genesisBlockId]
    Network.updateNetworkBlockchain(networkId, blockchain)

    numWallets = 2
		walletPublicKeyList = Enum.map(1..numWallets, fn(x) -> 
			Wallet.generateWallet(x, blockchain, networkId)
		end)

		[sender,receiver] = Enum.map(0..numWallets-1, fn(x) -> 
			Enum.fetch!(Enum.fetch!(walletPublicKeyList, x), 0)
		end)

		Bitcoin.mining(sender)
    Bitcoin.mining(receiver)
    :timer.sleep(3000)



    {:ok, transactionId: transactionId , genesisBlockId: genesisBlockId, networkId: networkId, sender: sender, receiver: receiver}
  end


  test "Mining", context do

    IO.puts ""
    IO.puts ""

    networkId = context[:networkId]
    genesisBlockId = context[:genesisBlockId]
    transactionId = context[:transactionId]
    
    sender = context[:sender]
    receiver = context[:receiver]


    amount = 10
    {_, _, _, _, _, _, _, _, _, senderBalanceBefore} = Wallet.getWalletState(sender)
    {_, _, _, _, _, _, _, _, _, receiverBalanceBefore} = Wallet.getWalletState(receiver)

    IO.puts "Checking balance of wallet 1 after mining is greater than 0"
    assert senderBalanceBefore > 0
    IO.puts "true"
    IO.puts "Checking balance of wallet 2 after mining is greater than 0"
    assert receiverBalanceBefore > 0
    IO.puts "true"
  end


  test "Wallet to Wallet transaction",context do
    IO.puts "Creating wallet to wallet transaction" 
    sender = context[:sender]
    receiver = context[:receiver]
    amount = 10
    Transaction.createWalletToWalletTx(sender,receiver,amount)
      
    {_, _, _, _, _, _, _, _, _, senderBalanceAfter} = Wallet.getWalletState(sender)
    {_, _, _, _, _, _, _, _, _, receiverBalanceAfter} = Wallet.getWalletState(receiver)

    IO.puts "senderBalanceBefore - amount = senderBalanceAfter?"
    assert 12.5 - amount == senderBalanceAfter
    IO.puts "true"
    IO.puts("receiverBalanceBefore + amount = receiverBalanceAfter?")
    assert 12.5 + amount == receiverBalanceAfter
    IO.puts "true"
  end

  

test "validate block added to blockhain", context do

    IO.puts ""
    IO.puts ""

    networkId = context[:networkId]
    genesisBlockId = context[:genesisBlockId]
    transactionId = context[:transactionId]
    
    sender = context[:sender]
    receiver = context[:receiver]

    blockchain  = Network.getNetworkBlockchain(networkId)

    blockId1 = Enum.fetch!(blockchain,length(blockchain)-1)
    blockId2 = Enum.fetch!(blockchain,length(blockchain)-2)

    {_, _, _, prevHash, _, _, _} = Block.getBlockState(blockId1)
    {_, _, hash, _, _, _, _} = Block.getBlockState(blockId2)

    IO.puts prevHash
    IO.puts hash
    IO.puts "hash of previous block == previous hash of current block?"
    assert prevHash == hash
  end
end
