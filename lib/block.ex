import Commons
import Transaction

defmodule Block do

    @doc """
    # Creates a new block with the genesis Transaction Id received in the input. 
    # Generates merkle root for the block and then calculates the final Hash for the block,
    # proceeding to update it in its state.
    """
    def genesisBlock(transactionId) do
        blockId = startBlock()
        {index, time, hash, prevHash, transactions, length, merkleRoot} = getBlockState(blockId)
        # IO.inspect({index, time, hash, prevHash, transactions, length, merkleRoot})


        # Update the block states
        updateBlockState(blockId, index, prevHash, [transactionId], merkleRoot)
        # IO.inspect transactionId
        {_,_, _, _, transactionHash, _} = getTxState(transactionId)

        merkleRoot = merkle_tree_hash([transactionHash])
        {index, time, hash, prevHash, transactions, length, merkleRoot} = getBlockState(blockId)

        # Calculate the hash for the block
        newHash = calculateHash(blockId)
        updateBlockHash(blockId, newHash)

        blockId
    end

    @doc """
    # Creates a new block with the transactions received in the input. 
    # Updates new index and prevHash of new block using the values oldBlockId. 
    # Calculates the hash of all transactions sent in the input and also generates Merkle Root. 
    # Finally after all calculations for the current block, it performs a hash of the current block and updates its hash value in its state and finally returns the new block id.
        """
    def generateBlock(oldBlockId, transactions) do

        # var newBlock Block
        newBlockId=startBlock()
        {oldBlockIndex, oldBlockTime, oldBlockHash, oldBlockPrevHash, oldBlocktransactions, oldBlockLength, oldBlockMerkleRoot} = getBlockState(oldBlockId)
        newIndex = oldBlockIndex + 1
        prevHash = oldBlockHash
        transactionHashes = Enum.map(transactions, fn(x) ->
            {_,_, _, _, transactionHash, _} = getTxState(x)
            transactionHash
        end)
        merkleRoot = merkle_tree_hash(transactionHashes)
        updateBlockState(newBlockId, newIndex, prevHash, transactions, merkleRoot)

        newHash = calculateHash(newBlockId)
        updateBlockHash(newBlockId, newHash)

        newBlockId
    end

    @doc """
    For the given block id received in the input, this function calculates the hash for the block. 
    It gets the current state of the block, concatenates the index, timestamp, previous hash, Merkle root and performs a SHA256 hash on this concatenated string. 
    This is the hash of the block and the value that is returned by the function.
    """
    def calculateHash(blockId) do
        {index, time, hash, prevHash, transactions, length, merkleRoot} = getBlockState(blockId)
        record = Integer.to_string(index) <> Integer.to_string(time) <> prevHash <> merkleRoot
        :crypto.hash(:sha256, record) |> Base.encode16
    end

    @doc """

    ## Block Structue

    Index:     is the position of the data record in the blockchain
    Timestamp: is automatically determined and is the time the data is written
    Hash:      is a SHA256 identifier representing this data record
    PrevHash:  is the SHA256 identifier of the previous record in the chain
    Transactions: List of transactions
    Length:    Length of the block
    Merkle Root:

    """
    def init(:ok) do
        timeStamp = :os.system_time(:millisecond)
        {:ok, {0,timeStamp,"", "", [], 0, ""}} 
    end
    def startBlock() do
        {:ok,pid}=GenServer.start_link(__MODULE__, :ok,[])
        pid
    end

    def handle_call({:GetBlockState}, _from ,state) do
        {:reply, state, state}
    end
    def getBlockState(pid) do
        GenServer.call(pid,{:GetBlockState})
    end


    def updateBlockState(blockId, newIndex, prevHash, transactions, merkleRoot) do
        updateBlockIndex(blockId, newIndex)
        updateBlockTransaction(blockId, transactions)
        updateBlockMerkleRoot(blockId, merkleRoot)
        updateBlockPrevHash(blockId, prevHash)
    end

    def updateBlockIndex(pid,blockIndex) do
        GenServer.call(pid, {:UpdateBlockIndex,blockIndex})
    end
    def handle_call({:UpdateBlockIndex,blockIndex}, _from ,state) do
        {a,b,c,d,e,f,g} = state
        state={blockIndex,b,c,d,e,f,g}
        {:reply,a,state}
    end

    def updateBlockHash(pid,hash) do
        GenServer.call(pid, {:UpdateBlockHash,hash})
    end
    def handle_call({:UpdateBlockHash,hash}, _from ,state) do
        {a,b,c,d,e,f,g} = state
        state={a,b,hash,d,e,f,g}
        {:reply,c,state}
    end

    def updateBlockPrevHash(pid,prevHash) do
        GenServer.call(pid, {:UpdateBlockPrevHash,prevHash})
    end
    def handle_call({:UpdateBlockPrevHash,prevHash}, _from ,state) do
        {a,b,c,d,e,f,g} = state
        state={a,b,c,prevHash,e,f,g}
        {:reply,e,state}
    end

    def updateBlockTransaction(pid,transaction) do
        GenServer.call(pid, {:UpdateBlockTransaction,transaction})
    end
    def handle_call({:UpdateBlockTransaction,transaction}, _from ,state) do
        {a,b,c,d,e,f,g} = state
        state={a,b,c,d,transaction,f,g}
        {:reply,e,state}
    end

    def updateBlockMerkleRoot(pid,merkleRoot) do
        GenServer.call(pid, {:UpdateBlockMerkleRoot,merkleRoot})
    end
    def handle_call({:UpdateBlockMerkleRoot,merkleRoot}, _from ,state) do
        {a,b,c,d,e,f,g} = state
        state={a,b,c,d,e,f,merkleRoot}
        {:reply,g,state}
    end

end
