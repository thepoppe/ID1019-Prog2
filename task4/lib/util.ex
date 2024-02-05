defmodule Util do

  #Reduce
  #returns the length
  def length1(list) do length1(list, 0) end
  def length1([], acc) do acc end
  def length1([h|t], acc) do length1(t, acc + h) end

  def length2([]) do 0 end
  def length2([_|t]) do 1 + length2(t) end


  #sums all the values from the list
  def sum1(list) do sum1(list, 0) end
  def sum1([], acc) do acc end
  def sum1([h|t], acc) do sum1(t, acc+h) end

  def sum([]) do 0 end
  def sum([h|t]) do h+sum(t) end


  #returns the produkt of all values in the list
  def prod1(list) do prod1(list, 1) end
  def prod1([], acc) do acc end
  def prod1([h|t], acc) do prod1(t, acc*h) end

  def prod([]) do 1 end
  def prod([h|t]) do h*prod(t) end


  #reverses the list
  def reverse([], list) do list end
  def reverse([h|t], list) do reverse(t, [h|list]) end


  #MAP
  #increment all values with incr
  def inc1(list, incr) do reverse(inc1(list, incr, []), []) end
  def inc1([], _, res) do res end
  def inc1([h|t], incr, list) do inc1(t, incr, [h|list]) end

  def inc([], val) do val end
  def inc([h|t], val) do [h+val| inc(t, val)] end


  #decrement all the values by decr
  def dec1(list, decr) do reverse(dec1(list, decr, []), []) end
  def dec1([], _, res) do res end
  def dec1([h|t], decr, list) do dec1(t, decr, [h|list]) end

  def dec([], _) do [] end
  def dec([h|t], val) do [h-val|dec(t)] end


  #multiplies all value by multiple
  def mul1(list, value) do reverse(mul1(list, value, []), []) end
  def mul1([], _, res) do res end
  def mul1([h|t], value, list) do mul1(t, value, [h|list]) end

  def mul([], _) do [] end
  def mul([h|t], val) do [h*val | mul(t, val)] end

  #returns a list of the results of the reminder from number
  def rem2([], _) do [] end
  def rem2([h|t], num) do
    [rem(h, num)|rem2(t,num)]
  end


  # filter
  #returns a list of all even number
  def even1([]) do [] end
  def even1([h|t]) do
    if rem(h,2) == 0 do
      [h| even1(t)]
    else
      even1(t)
    end
  end


  #returns a list of all odd numbers
  def odd1([]) do [] end
  def odd1([h|t]) do
    if rem(h,2) != 0 do
      [h|odd1(t)]
    else
      odd1(t)
    end
  end


  #returns a list where all number are evne divisible by number
  def div1([], _) do [] end
  def div1([h|t], num) do
    if rem(h, num) == 0 do
      [h|div1(t, num)]
    else
      div1(t, num)
    end
  end





  # higher grade i think = reduce. FOR length, sum, mul
  def foldr([], acc, op) do acc end
  def foldr([h|t], acc, op) do
    op.(h, foldr(t, acc, op))
  end

  def sum(list) do
    add =  fn a,b -> a+b end
    foldr(list, 0 , add)
  end

  # fold left is tail recursive
  def foldl([], acc, op) do acc end
  def foldl([h|t], acc, op) do foldl(t, op.foldl(h,acc),op) end


  def flatten_r(list) do
    f = fn a, acc -> a ++ acc end
    foldr(x,[], f)
  end

  def flatten_l(list) do
    f = fn a,acc -> acc ++ a end
    foldl(x, [], f)
  end


  #map applies a function to all elements in the list inc, dec, mul, div, rem
  def map([],_) do [] end
  def map([h|t], op) do [op.(h)| map(t,h)] end


  #filter for even odd rem div
  def filter([],_) do []end
  def filter([h|t],op)do
    if op.(h) do
      [h|filter(t,op)]
    else filter(t, op)
    end
  end

end
