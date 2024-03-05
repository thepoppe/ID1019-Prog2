defmodule Encode do

  def table(tree) do create_table(tree, [], Map.new) end

  def create_table({zero, one}, path, table) do
    table = create_table(zero, [0|path], table)
    create_table(one, [1|path], table)
  end
  def create_table(char, path, table) do Map.put(table, char, Enum.reverse(path))end


  def encode([],_) do [] end
  def encode([char|rest],table) do
    case Map.get(table,char) do
      :nil ->
        IO.puts("Error on #{char}")
        encode(rest, table)
        seq ->
          seq ++ encode(rest, table)
    end
  end
end
