defmodule Huff do

  def tree(sample) do
    freq = freq(sample)
    sorted = Enum.sort(freq, fn a,b -> elem(a,1) < elem(b,1) end)
    {tree, _} = build_tree(sorted)
    tree
  end

  def freq(sample) do
    freq(sample, Map.new())
  end
  def freq([], freq) do
    Map.to_list(freq)
  end
  def freq([char | rest], freq) do
    case Map.get(freq, char) do
      :nil -> freq(rest, Map.put(freq, char, 1))
      f -> freq(rest, Map.put(freq, char, f+1))
    end
  end

  def build_tree([node]) do node end
  def build_tree([{tree1, f1}, {tree2,f2} | rest]) do
    build_tree(insert({{tree1, tree2}, f1+f2}, rest))
  end

  def insert(node, []) do [node] end
  def insert(node1, [node2|rest] = sorted ) do
    if elem(node1,1) <= elem(node2,1) do
      [node1|sorted]
    else
      [node2 | insert(node1, rest)]
    end
  end

end
