defmodule Hinges do

  def test(material, time) do
    search(material,time, {260,40,30}, {180,60,24})
  end

  def search(m,t, {hm,ht,hp} = h, {lm,lt,lp} = l) when m>=hm and m >=lm and t>=ht and t>=lt do
    {h1,l1,p1} = search(m-hm, t-ht, h, l);
    {h2,l2,p2} = search(m-lm, t-lt, h, l);
    if p1 + hp > p2 + lp do
      {h1 + 1, l1, p1 + hp}
    else
      {h2, l2 + 1, p2 + lp}
    end
  end
  def search(m,t, {hm,ht,hp} = h, l) when m>=hm and t >=ht do
    {h1,l1,p1} = search(m-hm, t-ht, h, l);
    {h1 + 1, l1, p1 + hp}
  end
  def search(m,t, h, {lm,lt,lp} = l) when m>=lm and m >=lt do
    {h2,l2,p2} = search(m-lm, t-lt, h, l);
    {h2, l2 + 1, p2 + lp}
  end
  def search(_,_,_,_) do {0,0,0} end


  # WITH CACHE
  def test2(material, time) do
    mem = Memory.new()
    {res, mem}= search(material, time, {260,40,30}, {180,60,24}, mem)
    {:ok, res}
  end

  def search(m,t, {hm,ht,hp} = h, {lm,lt,lp} = l, mem) when m>=hm and m >=lm and t>=ht and t>=lt do
    {{h1,l1,p1}, updated} = check(m-hm, t-ht, h, l, mem);
    {{h2,l2,p2}, even_more} = check(m-lm, t-lt, h, l, updated);
    if p1 + hp > p2 + lp do
      {{h1 + 1, l1, p1 + hp}, even_more}
    else
      {{h2, l2 + 1, p2 + lp}, even_more}
    end
  end
  def search(m,t, {hm,ht,hp} = h, l, mem) when m>=hm and t >=ht do
    {{h1,l1,p1}, updated} = check(m-hm, t-ht, h, l, mem);
    {{h1 + 1, l1, p1 + hp}, updated}
  end
  def search(m,t, h, {lm,lt,lp} = l, mem) when m>=lm and m >=lt do
    {{h2,l2,p2}, updated} = check(m-lm, t-lt, h, l, mem);
    {{h2, l2 + 1, p2 + lp}, updated}
  end
  def search(_,_,_,_, mem) do {{0,0,0}, mem} end


  def check(m,t,h,l,mem) do
    case Memory.lookup({m,t}, mem) do
      nil ->
        {answer, updated} = search(m,t,h,l,mem);
        {answer, Memory.store({m,t}, answer, updated)}
      answer -> {answer, mem}
    end
  end
end

defmodule Memory do

  def new() do [] end
  def new2() do %{} end

  def store(k,v,mem) do
    [{k,v}| mem]
  end

  def store2(k,v,mem) do
    Map.put(mem,k,v)
  end

  def lookup(key, mem) do
    case List.keyfind(mem, key, 0 , :nil) do
      nil -> nil
      {_,v} -> v
    end
  end
  def lookup2(key, mem) do Map.get(mem,key) end

end
