defmodule Task4Test do
  use ExUnit.Case
  doctest Task4

  test "greets the world" do
    assert Task4.hello() == :world
  end
end
