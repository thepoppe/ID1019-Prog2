defmodule CtoF do

  def plus_2 (x) do
    x+2
  end

  def to_fahr (celsius) do
    celsius*1.8 + 32
  end

  def prod(a,b) do
    if (a == 0) do
      0
    else
    b + prod(a-1, b)
    end
  end


  def fib(n) do
    if n == 0 do
      0
    else
      if n==1 do
        1
      else
        fib(n-1) + fib(n-2)

      end
    end
  end


  def fib_no_if(n) do
    case n do
       0->0
       1->1
       _-> fib(n-1) + fib(n-2)

    end
  end


  def hej(x) do
    case x do
      :foo -> :hello
      :bar -> :bye
      true -> false
      _-> x
    end
  end


  def roman(x)do
    case x do
      :i -> 1
      :v -> 5
      :x -> 10
      :l -> 50
      :c -> 100
      :d -> 500
      :m -> 1000
    end
  end

  def sum(x) do
    case x do
      {} -> 0
      {a} -> a
      {a,b} -> a+b
      {a,b,c} -> a+b+c
      {a,b,c,d} -> a+b+c+d
    end
  end

end
