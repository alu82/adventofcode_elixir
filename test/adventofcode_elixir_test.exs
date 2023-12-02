defmodule AdventofcodeElixirTest do
  use ExUnit.Case
  doctest AdventofcodeElixir

  test "greets the world" do
    assert AdventofcodeElixir.hello() == :world
  end
end
