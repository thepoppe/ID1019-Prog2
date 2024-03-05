defmodule Huffman do
  def sample do
  'the quick brown fox jumps over the lazy dog
  this is a sample text that we will use when we build
  up a table we will only handle lower case letters and
  no punctuation symbols the frequency will of course not
  represent english but it is probably not that far off'
  end
  def text() do
  'this is something that we should encode'
  end

  def test do
  sample = sample()
  Enum.each(sample, fn s ->IO.write(s)end)
  IO.puts(" ")
  tree = tree(sample)
  encode = encode_table(tree)
  #decode = decode_table(tree)
  #text = text()
  #seq = encode(text, encode)
  #IO.puts("ENCODE")
  #Enum.each(seq, fn s ->IO.write(s)end)

  #:ok
  end


  ##EXPECTS A MAP NOT A LIST
  def decode_table(etable) do
    Enum.reduce(Map.to_list(etable), Map.new, fn {key, value}, map -> Map.put(map, value, key)end)
  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
    #huffman_lists(freq)
  end
  def encode_table(tree) do
  # Traverse teh tree and
    table = Enum.reverse(explore_left(tree, [], []))
    IO.inspect(table, charlists: :as_lists)
  end
  def decode_table(tree) do
  # To implement...
  end
  def encode(text, table) do
    Enum.reduce(text, [], fn char, sofar -> find_bits(char, table, sofar) end)
  end

  def freq(sample) do
    freq(sample, Map.new())
  end
  def freq([], freq) do
    freq
  end
  def freq([char | rest], freq) do
    {_,freq} = Map.get_and_update(freq, char, fn cur_val  ->
      if is_number(cur_val) do {cur_val, cur_val+1} else {nil, 1} end
    end)
    freq(rest, freq)
  end

  def huffman(map) do
    sorted = Enum.sort(map, &sort_key_value/2)
    sorted = Enum.map(sorted, fn {x,y} -> {:leaf, x,y}end)
    reduced = reduce_list(sorted)
    #IO.inspect(sorted)
    IO.inspect(reduced)
    #chunks = Enum.chunk_every(sorted, 2)
    #combine_chunks(chunks)
    #heap = Enum.reduce(map, Heap.new, fn key_value, heap -> Heap.push(heap,key_value) end) not in standard lib
  end

  def sort_key_value({_, value},{_, value2}) do if value < value2 do true else false end end
  def sort_key_value({_,_, value},{_,_, value2}) do if value < value2 do true else false end end

  #no fun with tuples adding tuples
  def reduce_list([tree | []]) do tree end
  def reduce_list([l1 = {:leaf,k1,v1}|[ l2 = {:leaf,k2,v2} | rest]]) do
    #IO.inspect(tree)
    new_kv_pair = {:node,{{:L,l1}, {:R,l2}}, v1+v2}
    reduce_list(Enum.sort([new_kv_pair|rest], &sort_key_value/2))
  end
  def reduce_list([c1 = {_,_,v1}|[c2 = {_,_,v2} | rest]]) do
    #IO.inspect(tree)
    new_kv_pair = {:node,{{:L,c1}, {:R,c2}}, v1+v2}
    reduce_list(Enum.sort([new_kv_pair|rest], &sort_key_value/2))
  end


  def explore_left({:leaf, key, freq}, total, path) do [{key, Enum.reverse(path)} | total] end
  def explore_left({:node, {{_,left}, {_,right}}, freq},  total, path) do
    #IO.inspect("LEFT: #{inspect(left)}")
    #IO.inspect("Right: #{inspect(right)}")
    total = explore_left(left, total, [0|path])
    explore_right(right, total, [1|path])
  end
  def explore_right({:leaf, key, freq}, total, path) do [{key, Enum.reverse(path)} | total] end
  def explore_right({:node, {{_,left}, {_,right}}, freq}, total, path) do
    total = explore_left(left, total,  [0|path])
    explore_right(right,total, [1|path])
  end

  def find_bits(char, table, sofar) do
    bit_list = find_key(char, table)
    #add_bits_to_list(Enum.reverse(bit_list), sofar)
    sofar ++ bit_list
  end

  #not good, map a lot better here
  def find_key(input, [{input, val}|table]) do val end
  def find_key(input, [_|table]) do find_key(input, table) end

  def add_bits_to_list([], sofar) do sofar end #temporary double reverse for readabiliity
  def add_bits_to_list([bit|next], sofar) do #bits should be backwards so we should be fine
    add_bits_to_list(next, [bit|sofar])
  end
end
