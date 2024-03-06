defmodule Decode do
## NOT GOOD
  def decode_table(etable) do
    Enum.reduce(Map.to_list(etable), [], fn {key, value}, acc ->[ { value, key} | acc] end)
  end

  #THIS IS VERY BAD, complecity n * djupet på trädet( log( antalet bokstäver))
  def decode([], _) do
    []
  end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end
  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 0) do
      {_, char} -> {char, rest}
      nil -> decode_char(seq, n+1, table)
    end
  end



  ##BETTER
  def decode2(encoded, tree) do
    decode2(encoded, tree,tree)
  end

  def decode2([],char,_), do: [char]
  def decode2([0|rest], {zero, _one}, tree) do decode2(rest, zero, tree) end
  def decode2([1|rest], {_zero, one}, tree) do decode2(rest, one, tree) end
  def decode2(encoded, char, tree) do [char | decode2(encoded, tree, tree) ]end

end
