defmodule Main do
  def demo() do
    #small(-1.25, -0.2, -0.9)
    small(-1.223, 0.135, -1.213)
    #small(-0.15, 0.9, 0.5)
    #a = 0.004
    #b = 0.0008
    #small(-0.365+a/2 + b, 0.674-a/2-b, -0.354-a-b)

  end

  def bench() do
    {time, _} = :timer.tc(fn -> bench_run(-2.6, 1.2, 1.2) end)
    output = "Time mandel_v3 using Cmplx Module\n" <> "#{div(time,1000)} \n"
    File.write("results.dat",output, [:append])
  end
  def bench_run(x0,y0,xn) do
    width = 1920
    height = 1080
    depth = 1024
    k = (xn - x0) / width
    Mandel_v3.mandelbrot(width, height, x0, y0, k, depth)
    :ok
  end


  def small(x0, y0, xn) do
      width = 2560
      height = 1440
      depth = :math.pow(2,10)
    k = (xn - x0) / width
    image = Mandel_v2.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("png/small.ppm", image)
  end
end
