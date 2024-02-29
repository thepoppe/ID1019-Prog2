defmodule Mandel do
  def mandelbrot(width, height, x, y, k, max) do
    trans = fn(w, h) ->
      Cmplx.new(x + k * (w - 1), y - k * (h - 1))
    end
    rows(width, height, trans, max, [])
  end

  def rows(_w, 0, _t, _max, acc) do
    #IO.puts("END ROWS")
    acc
  end
  def rows(w, h, t, max, acc) do
    #IO.puts("rows | w:#{w}|h#{h}");
    rows(w, h-1, t, max, [ row(w, h, t, max, []) | acc])
  end

  def row(0,_,_,_, acc) do
    #IO.puts("END LINE");
    acc
  end
  def row(w, h, t, max, acc) do
    #IO.puts("Line | w:#{w}|h#{h}");
    c = t.(w,h)
    #depth = Brot.mandelbrot(c, max);
    depth = Cmplx.mandelbrot(c, max);
    rgb = Color.convert_red(depth, max);
    row(w-1, h, t, max, [rgb | acc])
  end
end
