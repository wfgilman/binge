defmodule SharedTest do
  use ExUnit.Case
  doctest Shared

  test "greets the world" do
    assert Shared.hello() == :world
  end
end
