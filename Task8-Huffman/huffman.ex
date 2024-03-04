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
  tree = tree(sample)
  encode = encode_table(tree)
  decode = decode_table(tree)
  text = text()
  seq = encode(text, encode)
  decode(seq, decode)
  end
  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end
  def encode_table(tree) do
  # To implement...
  end
  def decode_table(tree) do
  # To implement...
  end
  def encode(text, table) do
  # To implement...
  end
  def decode(seq, tree) do
  # To implement...
  end

  def freq(sample) do
    freq(sample, Map.new())
  end
  def freq([], freq) do
    freq
  end
  def freq([char | rest], freq) do
    {_,freq} = Map.get_and_update(freq, "a", fn cur_val  ->
      if is_number(cur_val) do {cur_val, cur_val+1} else {nil, 1} end
    end)
    freq(rest, freq)
  end

  def huffman(map) do
    sorted = Enum.sort(freq, fn {key, value},{key2, value2} -> if value < value2 do true else false end end)
    Enum.each(sorted, fn x -> IO.inspect(x)end)
  end
end
