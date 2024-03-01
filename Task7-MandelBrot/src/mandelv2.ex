defmodule Mandel_v2 do
  def mandelbrot(width, height, x, y, k, max) do
    trans = fn(w, h) ->
      Cmplx.new(x + k * (w - 1), y - k * (h - 1))
    end
    rows(width, height, trans, max, [])
  end

  def rows(_w, 0, _t, _max, acc) do
    acc
  end
  def rows(w, h, t, max, acc) when h >=12 do
    f1 = Async.eval(fn -> row(w, h, t, max, []) end)
    f2 = Async.eval(fn -> row(w, h-1, t, max, [])end)
    f3 = Async.eval(fn -> row(w, h-2, t, max, [])end)
    f4 = Async.eval(fn -> row(w, h-3, t, max, [])end)
    f5 = Async.eval(fn -> row(w, h-4, t, max, [])end)
    f6 = Async.eval(fn -> row(w, h-5, t, max, [])end)
    f7 = Async.eval(fn -> row(w, h-6, t, max, []) end)
    f8 = Async.eval(fn -> row(w, h-7, t, max, [])end)
    f9 = Async.eval(fn -> row(w, h-8, t, max, [])end)
    f10 = Async.eval(fn -> row(w, h-9, t, max, [])end)
    f11 = Async.eval(fn -> row(w, h-10, t, max, [])end)
    f12 = Async.eval(fn -> row(w, h-11, t, max, [])end)
    f = [f1|[f2|[f3|[f4|[f5|[f6|[f7|[f8|[f9|[f10|[f11|[f12]]]]]]]]]]]]
    result = collect_results(f, acc)
    rows(w, h-12, t, max, result)
  end
  def rows(w, h, t, max, acc) when h >= 6 do
    f1 = Async.eval(fn -> row(w, h, t, max, []) end)
    f2 = Async.eval(fn -> row(w, h-1, t, max, [])end)
    f3 = Async.eval(fn -> row(w, h-2, t, max, [])end)
    f4 = Async.eval(fn -> row(w, h-3, t, max, [])end)
    f5 = Async.eval(fn -> row(w, h-4, t, max, [])end)
    f6 = Async.eval(fn -> row(w, h-5, t, max, [])end)
    f=[f1|[f2|[f3|[f4|[f5|[f6]]]]]]
    result = collect_results(f, acc)
    #IO.puts(length(result))
    rows(w, h-6, t, max, result)
    #rows(w, h-6, t, max, [Async.collect(f6)|[Async.collect(f5)|[Async.collect(f4)|[Async.collect(f3)|[Async.collect(f2)|[Async.collect(f1)| acc]]]]]])
  end
  def rows(w, h, t, max, acc) do
    rows(w, h-1, t, max, [ row(w, h, t, max, []) | acc])
  end

  def collect_results([], acc) do acc end
  def collect_results([ref|rest], acc) do
    collect_results(rest, [Async.collect(ref)| acc])
  end

  def row(0,_,_,_, acc) do
    acc
  end
  def row(w, h, t, max, acc) do
    c = t.(w,h)
    #depth = Brot.mandelbrot(c, max);
    depth = Cmplx.mandelbrot(c, max);
    rgb = Color.convert_blue(depth, max);
    row(w-1, h, t, max, [rgb | acc])
  end
end
