defmodule Wallet do

    def generateWallet(i, blockchain, networkId) do
        wId = startWallet()
        updateWalletName(wId, i)
        updateWalletBlockchain(wId, blockchain)
        updateWalletNetwork(wId, networkId)
        # updateWalletTransactions()
        {_, public_key, _, _, _, _, _, _, _, _} = getWalletState(wId)
        
        [wId, public_key]
    end

    @doc """
    name
    public key
    private key
    # signature
    list of all the other public kyes
    unused tansaction
    all transactions
    blockchain
    target
    networkId
    balance
    """
    def init(:ok) do
        {public_key, private_key} = with {public_key, private_key} <- :crypto.generate_key(:ecdh, :secp256k1),
            do: {Base.encode16(public_key), Base.encode16(private_key)}
        # Keep in mind that you have to decode both private key and public
        # key from Base16 encoded string into binary strings firstly!
        {:ok, {0,public_key, private_key,[], [], [], [], 2, nil, 0}} 
    end
    def startWallet do
        {:ok,pid}=GenServer.start_link(__MODULE__, :ok,[])
        pid
    end

    def updateWalletName(pid,name) do
        GenServer.call(pid, {:UpdateWalletName,name})
    end
    def handle_call({:UpdateWalletName,name}, _from ,state) do
        {a,b,c,d,e,f,g,h,i,j} = state
        state={name, b,c,d,e,f,g,h,i,j}
        {:reply,a,state}
    end


    def updateWalletTransactions(pid,transactions) do
        GenServer.call(pid, {:UpdateWalletTransactions,transactions})
    end
    def handle_call({:UpdateWalletTransactions,transactions}, _from ,state) do
        {a,b,c,d,e,f,g,h,i,j} = state
        state={a,b,c,d,e,transactions,g,h,i,j}
        {:reply,f,state}
    end

    def updateWalletBlockchain(pid,blockchain) do
        GenServer.call(pid, {:UpdateWalletBlockchain,blockchain})
    end
    def handle_call({:UpdateWalletBlockchain,blockchain}, _from ,state) do
        {a,b,c,d,e,f,g,h,i,j} = state
        state={a,b,c,d,e,f,blockchain,h,i,j}
        {:reply,g,state}
    end

    def updateWalletUnusedTransactions(pid,transaction,value) do
        GenServer.call(pid, {:UpdateWalletUnusedTransactions,transaction,value})
    end
    def handle_call({:UpdateWalletUnusedTransactions,transaction,value}, _from ,state) do
        {a,b,c,d,e,f,g,h,i,j} = state
        state={a,b,c,d,e ++ [transaction],f,g,h,i,j+value}
        {:reply,e,state}
    end

    def removeWalletUnusedTransactions(pid,transaction,value) do
        GenServer.call(pid, {:RemoveWalletUnusedTransactions,transaction,value})
    end
    def handle_call({:RemoveWalletUnusedTransactions,transaction,value}, _from ,state) do
        {a,b,c,d,e,f,g,h,i,j} = state
        state={a,b,c,d,e -- [transaction],f,g,h,i,j-value}
        {:reply,e,state}
    end


    def updateWalletPublicKeys(pid,keys) do
        GenServer.call(pid, {:UpdateWalletPublicKeys,keys})
    end
    def handle_call({:UpdateWalletPublicKeys,keys}, _from ,state) do
        {a,b,c,d,e,f,g,h,i,j} = state
        state={a,b,c,keys,e,f,g,h,i,j}
        {:reply,d,state}
    end

    def updateWalletTarget(pid,target) do
        GenServer.call(pid, {:UpdateWalletTarget,target})
    end
    def handle_call({:UpdateWalletTarget,target}, _from ,state) do
        {a,b,c,d,e,f,g,h,i,j} = state
        state={a,b,c,d,e,f,g,target,i,j}
        {:reply,h,state}
    end

    def updateWalletNetwork(pid,network) do
        GenServer.call(pid, {:UpdateWalletNetwork,network})
    end
    def handle_call({:UpdateWalletNetwork,network}, _from ,state) do
        {a,b,c,d,e,f,g,h,i,j} = state
        state={a,b,c,d,e,f,g,h,network,j}
        {:reply,i,state}
    end
    

    def getWalletState(tId) do
        GenServer.call(tId,{:GetWalletState})
    end

    def handle_call({:GetWalletState}, _from ,state) do
        {:reply, state, state}
    end


    def getWalletBalance(tId) do
        GenServer.call(tId,{:GetWalletBalance})
    end

    def handle_call({:GetWalletBalance}, _from ,state) do
        {a,b,c,d,e,f,g,h,i,j} = state
        IO.puts "| Wallet# #{a}     |  #{j} BTC |"
        {:reply, j, state}
    end

end