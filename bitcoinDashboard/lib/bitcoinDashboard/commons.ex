defmodule Commons do
    def waitIndefinitely() do
        waitIndefinitely()
    end

    def generateHash(key) do
        :crypto.hash(:sha256, :crypto.hash(:sha256, key)) |> Base.encode16 
    end


    @doc """
    Calculate the root hash of the merkle tree built from given list of hashes"
    """
    def merkle_tree_hash(list)

    def merkle_tree_hash([hash]), do: hash
    def merkle_tree_hash(list) when rem(length(list), 2) == 1, do: (list ++ [List.last(list)]) |> merkle_tree_hash
    def merkle_tree_hash(list) do
        list
            |> Enum.chunk(2)
            |> Enum.map(fn [a, b] -> generateHash(a <> b) end)
            |> merkle_tree_hash
    end
end