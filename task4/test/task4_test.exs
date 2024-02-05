defmodule Task4Test do
  use ExUnit.Case
  doctest Task4

  test "length12" do
    x=[1,2,3,4,5]
    assert(Util.length1(x) == 5,"length1 error")
    assert(Util.length2(x) == 5,"length2 error")
  end
  test "sum12" do
    x=[1,2,3,4,5]
    assert(Util.sum1(x) == 15,"sum1 error")
    assert(Util.sum(x) == 15,"sum error")
  end
  test "prod" do
    x=[1,2,3,4,5]
    assert(Util.prod1(x) == (2*3*4*5),"prod1 error")
    assert(Util.prod(x) == (2*3*4*5),"prod error")
  end
  test "incr" do
    x=[1,2,3,4,5]
    val = 10
    assert(Util.inc1(x, val) == [11,12,13,14,15],"inc1 error")
    assert(Util.inc(x, val) == [11,12,13,14,15],"inc error")
  end
  test "dec" do
    x= [11,12,13,14,15]
    val = 10
    assert(Util.dec1(x, val) == [1,2,3,4,5],"dec1 error")
    assert(Util.dec(x, val) == [1,2,3,4,5],"dec error")
  end
  test "mul" do
    x= [11,12,13,14,15]
    val = 2
    assert(Util.mul1(x, val) == [22,24,26,28,30],"dec1 error")
    assert(Util.mul(x, val) == [22,24,26,28,30],"dec error")
  end
  test "rem2" do
    x= [11,12,13,14,15]
    val = 3
    list = Util.rem2(x, val)
    assert(list == [2, 0, 1, 2, 0], "error, list: is not [2, 0, 1, 2, 0]")
  end
  test "even1" do
    x= [11,12,13,14,15,16,17,18]
    assert(Util.even1(x) == [12,14,16,18])
  end
  test "odd1" do
    x= [11,12,13,14,15,16,17,18]
    assert(Util.odd1(x) == [11,13,15,17])
  end
  test "div1" do
    x= [11,12,13,14,15,16,17,18]
    v=3
    assert(Util.div1(x,v) == [12,15,18])
  end

end
