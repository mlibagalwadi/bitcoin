defmodule GenerateRandomStringTest do
    use ExUnit.Case
    doctest GenerateRandomString

    @tag :validateRandomStringLength
    test "Random string nonce Length Valid" do
        assert String.length(GenerateRandomString.randomizer(5)) == 5
    end

end
