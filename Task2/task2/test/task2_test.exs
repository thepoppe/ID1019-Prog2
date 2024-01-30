defmodule Task2Test do
  use ExUnit.Case
  doctest Task2

  test "list_functions" do
    IO.puts("\nTesting EnvList")
    map = EnvList.new()
    IO.inspect(map)
    map = EnvList.add(map, :a, 1)
    IO.inspect("add :a,1 : #{inspect(map)}")
    map = EnvList.add(map, :b, 2)
    IO.inspect("add :b,2 : #{inspect(map)}")
    map = EnvList.add(map, :c, 4)
    IO.inspect("add :c,4 : #{inspect(map)}")
    map = EnvList.add(map, :b, 5)
    IO.inspect("add :b,5 : #{inspect(map)}")

    res = EnvList.lookup(map, :a)
    IO.inspect("lookup :a : #{inspect(res)}")
    res = EnvList.lookup(map, :b)
    IO.inspect("lookup :b : #{inspect(res)}")
    res = EnvList.lookup(map, :c)
    IO.inspect("lookup :c : #{inspect(res)}")
    res = EnvList.lookup(map, :x)
    IO.inspect("lookup :x : #{inspect(res)}")

    map = EnvList.remove(map, :x )
    IO.inspect("remove :x : #{inspect(map)}")
    map = EnvList.remove(map, :a)
    IO.inspect("remove :a : #{inspect(map)}")
    map = EnvList.remove(map, :b)
    IO.inspect("remove :b : #{inspect(map)}")
    map = EnvList.remove(map, :c)
    IO.inspect("remove :c : #{inspect(map)}")
    :done
  end

  test "tree_test" do
    IO.puts("\nTesting EnvTree")
    map = EnvTree.add(nil, :b, 4)
    IO.inspect("add :b,4 : #{inspect(map)}")
    map = EnvTree.add(map, :a, 1)
    IO.inspect("add :a,1 : #{inspect(map)}")
    map = EnvTree.add(map, :d, 2)
    IO.inspect("add :d,2 : #{inspect(map)}")
    map = EnvTree.add(map, :c, 5)
    IO.inspect("add :c,5 : #{inspect(map)}")
    map = EnvTree.add(map, :c, 50)
    IO.inspect("add :c,50 : #{inspect(map)}")

    res = EnvTree.lookup(map, :a)
    IO.inspect("lookup :a : #{inspect(res)}")
    res = EnvTree.lookup(map, :b)
    IO.inspect("lookup :b : #{inspect(res)}")
    res = EnvTree.lookup(map, :c)
    IO.inspect("lookup :c : #{inspect(res)}")
    res = EnvTree.lookup(map, :x)
    IO.inspect("lookup :x : #{inspect(res)}")
    :done
  end

  test "remove_tree" do
    IO.puts("\nTesting remove function")
    map = EnvTree.add(nil, 5, :test)
    map = EnvTree.add(map, 2, :test)
    map = EnvTree.add(map, 1, :test)
    map = EnvTree.add(map, 3, :test)
    map = EnvTree.add(map, 7, :test)
    map = EnvTree.add(map, 6, :test)
    map = EnvTree.add(map, 8, :test)
    IO.inspect("First strucute: #{inspect(map)}")
    map = EnvTree.remove(map, 1)
    IO.inspect("1 removed: #{inspect(map)}")
    map = EnvTree.remove(map, 3)
    IO.inspect("3 removed: #{inspect(map)}")
    map = EnvTree.remove(map, 7)
    IO.inspect("7 removed: #{inspect(map)}")
    map = EnvTree.add(map, 7, :test)
    IO.inspect("7 added: #{inspect(map)}")
    IO.inspect(map)
    map = EnvTree.remove(map, 5)
    IO.inspect("5 removed: #{inspect(map)}")
    map = EnvTree.add(map, 1, :test)
    map = EnvTree.add(map, 2, :test)
    map = EnvTree.add(map, 3, :test)
    map = EnvTree.add(map, 4, :test)
    map = EnvTree.add(map, 5, :test)
    map = EnvTree.add(map, 6, :test)
    map = EnvTree.add(map, 7, :test)
    map = EnvTree.add(map, 8, :test)
    map = EnvTree.add(map, 9, :test)
    map = EnvTree.add(map, 10, :test)
    map = EnvTree.add(map, 11, :test)
    map = EnvTree.add(map, 12, :test)
    IO.inspect("larger tree: #{inspect(map)}")
    map = EnvTree.remove(map, 6)
    IO.inspect("root 6 removed: #{inspect(map)}")
  end

end