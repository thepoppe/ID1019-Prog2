defmodule Test do

  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off åäöABCDEFGHIJKLMNOPQRSTUVWXYZÅÄÖ1234567890+\",.-:;!?\( \)<>=\' é'
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
    Decode.decode(encoded, d_table)
    #Decode.decode(encoded, tree)
  end

 def bench1 do
  {:ok,text, _len, size} = read()
  #IO.puts(text)
  sample = sample()
  {total, {_separate, _tree, encoded, _decoded}} = :timer.tc(fn ->
    {t1, tree} =    :timer.tc(fn -> Huff.tree(sample) end)
    {t2, e_table} = :timer.tc(fn -> Encode.table(tree) end)
    {t3, encoded} = :timer.tc(fn -> Encode.encode(text, e_table) end)
    {t4, d_table} = :timer.tc(fn -> Decode.decode_table(e_table) end)
    {t5, decoded} = :timer.tc(fn -> Decode.decode(encoded, d_table) end)
    {[t1,t2,t3,t4,t5], tree, encoded, decoded}
  end)
  #tree_size = Kernel.byte_size(tree)
  e = div(length(encoded), 8)
  r = Float.round(e / size, 3)
  IO.puts("Time for completion #{total}")
  IO.puts("source #{size} bytes, encoded #{e} bytes, compression #{r}")
 end
 def bench2 do
  {:ok,text, _len, size} = read()
  #IO.puts(text)
  {total, {_separate, _tree, encoded, _decoded}} = :timer.tc(fn ->
    {t1, tree} =    :timer.tc(fn -> Huff.tree(text) end)
    {t2, e_table} = :timer.tc(fn -> Encode.table(tree) end)
    {t3, encoded} = :timer.tc(fn -> Encode.encode(text, e_table) end)
    {t4, d_table} = :timer.tc(fn -> Decode.decode_table(e_table) end)
    {t5, decoded} = :timer.tc(fn -> Decode.decode(encoded, d_table) end)
    {[t1,t2,t3,t4,t5], tree, encoded, decoded}
  end)
  #tree_size = Kernel.byte_size(tree)
  e = div(length(encoded), 8)
  r = Float.round(e / size, 3)
  IO.puts("Time for completion #{total}")
  IO.puts("source #{size} bytes, encoded #{e} bytes, compression #{r}")
 end
 def bench3 do
  {:ok,text, _len, size} = read()
  #IO.puts(text)
  {total, {_separate, _tree, encoded, _decoded}} = :timer.tc(fn ->
    {t1, tree} =    :timer.tc(fn -> Huff.tree(text) end)
    {t2, e_table} = :timer.tc(fn -> Encode.table(tree) end)
    {t3, encoded} = :timer.tc(fn -> Encode.encode(text, e_table) end)
    {t4, _d_table} = :timer.tc(fn -> Decode.decode_table(e_table) end)
    {t5, decoded} = :timer.tc(fn -> Decode.decode2(encoded, tree) end)
    {[t1,t2,t3,t4,t5], tree, encoded, decoded}
  end)
  #tree_size = Kernel.byte_size(tree)
  e = div(length(encoded), 8)
  r = Float.round(e / size, 3)
  IO.puts("Time for completion #{total}")
  IO.puts("source #{size} bytes, encoded #{e} bytes, compression #{r}")
 end
 def bench4 do
  {:ok,text, _len, size} = read()
  #IO.puts(text)
  {total, {_separate, _tree, encoded, _decoded}} = :timer.tc(fn ->
    {t1, tree} =    :timer.tc(fn -> Huff.tree(text) end)
    {t2, e_table} = :timer.tc(fn -> Encode.table(tree) end)
    {t3, encoded} = :timer.tc(fn -> Encode.encode2(text, e_table) end)
    {t4, _d_table} = :timer.tc(fn -> Decode.decode_table(e_table) end)
    {t5, decoded} = :timer.tc(fn -> Decode.decode2(encoded, tree) end)
    {[t1,t2,t3,t4,t5], tree, encoded, decoded}
  end)
  #tree_size = Kernel.byte_size(tree)
  e = div(length(encoded), 8)
  r = Float.round(e / size, 3)
  IO.puts("Time for completion #{total}")
  IO.puts("source #{size} bytes, encoded #{e} bytes, compression #{r}")
 end

 def read() do
  text = File.read!("kallocain.txt")
  chars = String.to_charlist(text)
  {:ok, chars, String.length(text), Kernel.byte_size(text)}
  end

end
