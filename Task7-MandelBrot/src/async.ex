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
