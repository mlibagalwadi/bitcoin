defmodule NetworkTest do
    use ExUnit.Case
    doctest Network

    setup do 
        networkId = Network.generateNetwork()
        {:ok,networkId: networkId}
    end

    @tag :network
    test "Network is Alive",context do
        IO.puts ""
        IO.puts "Is network alive?"
        IO.puts context[:networkId] != nil
        assert context[:networkId] != nil
    end

end
