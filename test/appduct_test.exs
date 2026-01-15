defmodule AppductTest do
  use ExUnit.Case
  doctest Appduct

  test "greets the world" do
    assert Appduct.hello() == :world
  end
end
