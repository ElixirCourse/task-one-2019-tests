defmodule DequeTest do
  use ExUnit.Case
  doctest Deque

  test "greets the world" do
    assert Deque.hello() == :world
  end
end
