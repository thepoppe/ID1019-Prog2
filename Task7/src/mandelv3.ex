defmodule Mandel_v3 do
  def mandelbrot(width, height, x, y, k, max) do
    trans = fn(w, h) ->
      Cmplx.new(x + k * (w - 1), y - k * (h - 1))
    end
    rows(width, height, trans, max, self())
    collect(height, [])
  end

  def rows(_w, 0, _t, _max, _ctrl) do :ok end
  def rows(w, h, t, max, ctrl) do
    spawn_link(fn -> report(w, h, t, max, ctrl) end)
    rows(w, h-1, t, max, ctrl)
  end


  def report(w, h, t, max, ctrl)do
    res = row(w, h, t, max, [])
    send(ctrl, {:row, h, res})
  end


  def row(0,_,_,_, acc) do acc end
  def row(w, h, t, max, acc) do
    c = t.(w,h)
    #depth = Brot.mandelbrot(c, max);
    depth = Cmplx.mandelbrot(c, max);
    rgb = Color.convert_red(depth, max);
    row(w-1, h, t, max, [rgb | acc])
  end


  def collect(0, acc) do acc end
  def collect(h, acc) do
    receive do
      {:row, ^h, res} -> collect(h-1, [res | acc])
    end
  end
end
