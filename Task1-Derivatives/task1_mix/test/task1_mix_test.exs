defmodule Task1MixTest do
  use ExUnit.Case
  doctest Task1Mix

  test "greets the world" do
    assert Task1Mix.hello() == :world
  end

  test "test_div" do
    Task1.test_div()
  end
  test "test_ln" do
    Task1.test_ln()
  end

  test "test_all" do
    Task1.test1()
    Task1.test2()
    Task1.test_ln()
    Task1.test_sqrt()
    Task1.test_div()
    Task1.test_sin()
    Task1.test_final()
    Task1.test_ass_mul()

  end
end
