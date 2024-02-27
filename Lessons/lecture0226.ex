defmodule Fib do

  def fib(1) do 1 end
  def fib(2) do 1 end
  def fib(n) do
    fib(n-1) + fib(n-2)
  end

  def fab(1) do 1 end
  def fab(2) do 1 end
  def fab(n) when n>2 do
    r1 = Async.eval(fn -> fab(n-1) end)
    r2 = Async.eval(fn -> fab(n-2) end)
    f1 = Async.collect(r1)
    f2 = Async.collect(r2)

    #me = self();
    #ref1 = make_ref()
    #ref1 = make_ref()
    #s1 = spawn(fn -> send(me, {:result, ref1, fab(n-1)}) end)
    #s2 = spawn(fn -> send(me, {:result, ref2, fab(n-2)}) end)
    #f1 = receive do
    #  {:result, ^ref1, x} -> x
    #end
    #f2 = receive do
    #  {:result,^ref2, x} -> x
    #end
    f1+f2
  end
end


#mindre processer

def fob(1,_) do 1 end
def fob(2,_) do 1 end
def fob(n, k) when n > 2 and n < k do
  fib(n)
end
def fob(n, k) when n > 2 do
  r1 = Async.eval(fn -> fob(n-1, k) end)
  r2 = Async.eval(fn -> fob(n-2, k) end)
  f1 = Async.collect(r1)
  f2 = Async.collect(r2)
  f1 +f2
end

defmodule Async do

  def eval(f) do
    me = self()
    ref = make_ref()
    spawn_link(fn -> send(me,{:async, ref, f.()})end)
    ref
  end

  def collect(ref) do
    receive do
      {:async, ^ref, res} -> res
    end
  end

end
