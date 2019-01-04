# import Block
# import Transaction

defmodule Network do
  use GenServer
  def generateNetwork do
    networkId = startNetwork()
    networkId
  end

  @doc """

  ## Network State Structue
    blockchain:   List of block IDs - blockchain
    unconfirmedTransactions: List of unconfirmed transactions in the transaction pool
    walletIdPublicKeysMap:  Map of all wallet ids and their public keys in the network
    confirmedTransactions: List of transactions in the transaction pool
  """
  def init(:ok) do
    timeStamp = :os.system_time(:millisecond)
    {:ok, {[], [], [], []}}
  end
  def startNetwork do
    {:ok,pid}=GenServer.start_link(__MODULE__, :ok,[])
    pid
  end

  def handle_call({:GetNetworkBlockchain}, _from ,state) do
    {a,b,c,d} = state
    {:reply, a, state}
  end
  def getNetworkBlockchain(pid) do
    GenServer.call(pid,{:GetNetworkBlockchain})
  end

  def handle_call({:GetNetworkState}, _from ,state) do
    {:reply, state, state}
  end

  def getNetworkState(pid) do
    GenServer.call(pid,{:GetNetworkState})
  end


  def handle_call({:GetNetworkUnconfirmedTransactionPool}, _from ,state) do
    {a,b,c,d} = state
    {:reply, b, state}
  end
  def getNetworkUnconfirmedTransactionPool(pid) do
    GenServer.call(pid,{:GetNetworkUnconfirmedTransactionPool})
  end



  def handle_call({:GetNetworkConfirmedTransactionPool}, _from ,state) do
    {a,b,c,d} = state
    {:reply, d, state}
  end
  def getNetworkConfirmedTransactionPool(pid) do
    GenServer.call(pid,{:GetNetworkConfirmedTransactionPool})
  end

  def updateNetworkUnconfirmedTransactionPool(pid,transaction) do
    GenServer.call(pid, {:UpdateNetworkUnconfirmedTransactionPool,transaction})
  end
  def handle_call({:UpdateNetworkUnconfirmedTransactionPool,transaction}, _from ,state) do
    {a,b,c,d} = state
    state={a, b ++ [transaction],c,d}
    {:reply,b,state}
  end

  def removeNetworkUnconfirmedTransactionFromPool(pid, transactions) do
    GenServer.call(pid, {:RemoveNetworkUnconfirmedTransactionFromPool,transactions})
  end
  def handle_call({:RemoveNetworkUnconfirmedTransactionFromPool, transactions}, _from ,state) do
    {a,b,c,d} = state
    state={a, b -- transactions,c,d}
    {:reply,b,state}
  end

  def updateNetworkBlockchain(pid,blockchain) do
    GenServer.call(pid, {:UpdateNetworkBlockchain,blockchain})
  end
  def handle_call({:UpdateNetworkBlockchain,blockchain}, _from ,state) do
    {a,b,c,d} = state
    state={blockchain,b,c,d}
    {:reply,a,state}
  end

  def updateNetworkWalletIdMaps(pid,map) do
    GenServer.call(pid, {:UpdateNetworkWalletIdMaps,map})
  end
  def handle_call({:UpdateNetworkWalletIdMaps,map}, _from ,state) do
    {a,b,c,d} = state
    state={a,b,c ++ map,d}
    {:reply,c,state}
  end

  def updateNetworkConfirmedTransactionPool(pid,transaction) do
    GenServer.call(pid, {:UpdateNetworkConfirmedTransactionPool,transaction})
  end
  def handle_call({:UpdateNetworkConfirmedTransactionPool,transaction}, _from ,state) do
    {a,b,c,d} = state
    state={a,b,c,d++ [transaction]}
    {:reply,d,state}
  end

  def removeNetworkConfirmedTransactionPool(pid,transaction) do
    GenServer.call(pid, {:RemoveNetworkConfirmedTransactionPool,transaction})
  end
  def handle_call({:RemoveNetworkConfirmedTransactionPool,transaction}, _from ,state) do
    {a,b,c,d} = state
    state={a,b,c,d-- [transaction]}
    {:reply,d,state}
  end

  def getNetworkId do
		netID =:ets.lookup(:table, "networkId")
		elem(Enum.fetch!(netID,0),1)
	end

end
