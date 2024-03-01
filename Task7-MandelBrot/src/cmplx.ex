defmodule Cmplx do

  def new(r,i) do
    #return the complex number with the real value r and imaginary i
    {:cmplx, r, i}
  end

  def add(a,b) do
    #adds two complex numbers
    {:cmplx, xa, ya} = a
    {:cmplx, xb, yb} = b
    {:cmplx, xa+xb, ya+yb}
  end

  def sqr(a) do
    #squares the complex number
    {:cmplx, x, y} = a
    {:cmplx, x*x - y*y, 2*x*y}
  end

  def abs(a) do
    #the absolute value of the complex number
    {:cmplx, x, y} = a
    :math.sqrt(x*x + y*y)


  end


  #Calculate mandel brot directly in cmplx
  #This makes the arithmetic operations happen directly instead of fetching structsures from memory
  def mandelbrot({:cmplx, cr, ci}, max) do
    zr = 0;
    zi = 0;
    test(0, zr, zi, cr, ci, max)
  end
  def test(i, _zr, _zi, _cr, _ci, max) when i == max do 0 end
  def test(i, zr, zi, cr, ci, max) do
    zr2 = zr*zr
    zi2 = zi*zi
    #IO.puts(i)

    #abs(x) = :math.sqrt(r*r + i*i) -> abs(x) ^2 = r*r + i*i
    if zr2 + zi2 > 4 do
        i
      else
        #{:cmplx, r, i}^2 =   {:cmplx, r*r - i*i, 2*r*i} ->
          # zr_square =  r*r - i*i. zi_square = 2*r*i
        zr_square = zr2-zi2
        zi_square = 2*zr*zi
        #(zn+2) = (z+1n)^2 + c =  {:cmplx, zr_square+cr, zi_square+ci}
        test(i+1, zr_square+cr, zi_square+ci, cr, ci, max)
      end
    end


end
