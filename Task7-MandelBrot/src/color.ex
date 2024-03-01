defmodule Color do

  def convert_blue(depth, max) do
    a = depth/max * 4
    x = trunc(a)
    y = trunc(255*(a-x))

    case trunc(a) do
      0-> {:rgb, 0,0,y}
      1-> {:rgb, 0,y,255}
      2-> {:rgb, 0,255,255-y}
      3-> {:rgb, y, 255, 0}
      4-> {:rgb, 255, 255-y, 0}
    end
  end
  def convert_red(depth, max) do
    a = depth/max * 4
    x = trunc(a)
    y = trunc(255*(a-x))

    case trunc(a) do
      0-> {:rgb, y,0,0}
      1-> {:rgb, 255,y,0}
      2-> {:rgb, 255-y,255,0}
      3-> {:rgb, 0, 255, y}
      4-> {:rgb, 0, 255-y, 255}
    end
  end

end
