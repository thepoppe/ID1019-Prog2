defmodule Test do

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
    IO.inspect("Length of sample: #{length(sample)}")
    tree = Huff.tree(sample)
    e_table = Encode.table(tree)
    text = text()
    encoded = Encode.encode(text, e_table)
    Enum.each(encoded, fn x -> IO.write(x) end)
    IO.write("\n")
    d_table = Decode.decode_table(e_table)
    decoded = Decode.decode2(encoded, tree)
  end

  def test2 do

  end

  def read(file) do
    str=File.read!(file)

  end

end
