defmodule NotifyTest do
  use ExUnit.Case
  doctest Notify

  test "greets the world" do
    assert Notify.hello() == :world
  end
end
