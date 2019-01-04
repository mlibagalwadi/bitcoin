defmodule CommonsTest do
    use ExUnit.Case
    doctest Commons

    @tag :validateHashLength
    test "Hash Length Valid" do
        IO.puts ""
        IO.puts "Is hash length 64?"
        IO.puts String.length(Commons.generateHash("a")) == 64
        assert String.length(Commons.generateHash("a")) == 64
    end

    @tag :validateMerkleRoot
    test "Merkle Root Valid" do
        assert Commons.merkle_tree_hash([Commons.generateHash("a")]) == Commons.generateHash("a")
        assert Commons.merkle_tree_hash([Commons.generateHash("a") , Commons.generateHash("b")]) == Commons.generateHash(Commons.generateHash("a")<>Commons.generateHash("b"))
        assert Commons.merkle_tree_hash([Commons.generateHash("a") , Commons.generateHash("b"),Commons.generateHash("c")]) == Commons.generateHash(Commons.generateHash(Commons.generateHash("a")<>Commons.generateHash("b"))<>Commons.generateHash(Commons.generateHash("c")<>Commons.generateHash("c")))
    end




end
