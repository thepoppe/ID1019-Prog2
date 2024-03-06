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
  def encode2(seq,table) do encode2(seq,table,[]) end
  def encode2([],_, acc) do Enum.reverse(acc) end
  def encode2([char|rest],table, acc) do
    case Map.get(table,char) do
      :nil ->
        IO.puts("Error on #{char}")
        encode(rest, table)
        seq ->
           encode2(rest, table, [seq|acc])
    end
  end
end
