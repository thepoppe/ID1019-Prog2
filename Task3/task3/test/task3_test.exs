defmodule Task3Test do
  use ExUnit.Case
  doctest Task3

test "main test" do
  env = Map.new()
  env = Map.put(env, :x, 10)
  env = Map.put(env, :y, 5)
  env = Map.put(env, :z, 3)
  expr1 = {:add, {:num, 3}, {:q, 1,2}} #3 + 1/2 = 7/2
  expr2 = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:q, 1,2}} #2x + 3 + 1/2 => 2*10 + 3+ 1/2 = 47/2
  expr3 = {:add, {:num, 5}, {:sub, {:var, :x}, {:num, 2}}} # 5+ (x-2) => 5 + (10-2) = 13
  expr4 = {:add, {:num, 5}, {:sub, {:var, :y}, {:num, 2}}} # 5+ (y-2) => 5 + (58-2) = 8
  expr5 = {:add, {:num, 5}, {:sub, {:var, :a}, {:num, 2}}} # 5+ (a-2) => ":error, :a not found"
  expr6 = {:div, {:mul, {:var, :z}, {:num, 10}}, {:num, 2}} # (z*10) / 2 => (3*10)/2 = 15
  expr7 = {:mul, {:add, {:num, 3}, {:var, :x}}, {:div, {:num, 6}, {:q, 2, 3}}} # (3+x) * (6/(2/3)) => (3+10) *  (6/(2/3)) = 117
  expr8 = {:add, {:mul, {:num, 2}, {:var, :y}}, {:div, {:add, {:var, :x}, {:num, 3}}, {:q, 5, 2}}} # 2y + (x+3)/(5/2) => 2*5 + (10+3)/(5/2) = 76/5
  expr9 = {:div,
  {:mul, {:mul, {:num, 3}, {:var, :x}}, {:sub, {:mul, {:num, 4}, {:var, :y}}, {:var, :z}}},
  {:add, {:mul, {:q, 5, 2}, {:var, :x}}, {:div, {:add, {:num, 10}, {:var, :z}}, {:num, 2}}}}
  # (3*x * (4*y - z)) / ((5 / 2)*x + (10 + z) / 2) = (30 + (20-3)) / ((5/2)*10 + (10+3)/2)) = 340/21 = 1020/63 goodenough

  assert((Task3.main(expr1,env) == {:rational, "7/2"}), "ISSUES1")
  assert((Task3.main(expr2,env) == {:rational, "47/2"}), "ISSUES2")
  assert((Task3.main(expr3,env) == {:ok, "13"}), "ISSUES3")
  assert((Task3.main(expr4,env) == {:ok, "8"}), "ISSUES4")
  assert((Task3.main(expr5,env) == {:error, ":a not found"}), "ISSUES5")
  assert((Task3.main(expr6,env) == {:ok,  "15"}), "ISSUES6")
  assert((Task3.main(expr7,env) == {:ok, "117"}), "ISSUES7")
  assert((Task3.main(expr8,env) == {:rational, "76/5"}), "ISSUES8")
  assert((Task3.main(expr9,env) == {:rational, "340/21"}), "ISSUESHARD")

end
end
