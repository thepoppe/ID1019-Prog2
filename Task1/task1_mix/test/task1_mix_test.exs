defmodule Task1MixTest do
  use ExUnit.Case
  doctest Task1Mix

  test "greets the world" do
    assert Task1Mix.hello() == :world
  end

  test "test_div" do
    Task1.test_div()
  end
end
