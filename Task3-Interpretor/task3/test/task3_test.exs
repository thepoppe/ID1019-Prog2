defmodule Task3Test do
  use ExUnit.Case
  doctest Task3

test "main test task3" do
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

  assert((Task3.main(expr1,env) == {:rational, "7/2"}), "ISSUES on 1")
  assert((Task3.main(expr2,env) == {:rational, "47/2"}), "ISSUES on 2")
  assert((Task3.main(expr3,env) == {:ok, "13"}), "ISSUES on 3")
  assert((Task3.main(expr4,env) == {:ok, "8"}), "ISSUES on 4")
  assert((Task3.main(expr5,env) == {:error, ":a not found"}), "ISSUES on 5")
  assert((Task3.main(expr6,env) == {:ok,  "15"}), "ISSUES on 6")
  assert((Task3.main(expr7,env) == {:ok, "117"}), "ISSUES on 7")
  assert((Task3.main(expr8,env) == {:rational, "76/5"}), "ISSUE on 8")
  assert((Task3.main(expr9,env) == {:rational, "340/21"}), "ISSUES on 9")

end

test "lambda and apply" do
  seq = [{:match, {:var, :x}, {:atm, :a}},
          {:match, {:var, :f},
          {:lambda, [:y], [:x], [{:cons, {:var, :x}, {:var, :y}}]}},
          {:apply, {:var, :f}, [{:atm, :b}]}
        ] # x = :a, f = fn y -> {x,y} end: f.(:b)
{:ok, res} = Eager.eval_seq(seq, Env.new())
assert(res  == {:a, :b}, "did not evaluate correctly")
end

test "eval scope, why do we do this" do
  seq = [{:match, {:var, :x}, {:atm, :a}},
        {:match, {:var, :x},{:atm, :b}},
        {:cons, {:var, :x}, {:atm, :done}}
      ] # x = :a; x = :b; {x, :done} => {:b, :done}
  {:ok, res} = Eager.eval_seq(seq, Env.new())
  assert(res  == {:b, :done}, "did not evaluate correctly")
end

test "Case1, Case2, what is this" do
  seq = [{:match, {:var, :x}, {:atm, :a}},
        {:case, {:var, :x},
        [{:clause, {:atm, :b}, [{:atm, :ops}]},
        {:clause, {:atm, :a}, [{:atm, :yes}]}
        ]}
        ] #x = :a; case x do :b -> :ops, :a -> :yes end
  {:ok, res} = Eager.eval_seq(seq, Env.add(:x, :toberemoved, []))
  assert(res  == :yes, "did not evaluate correctly")
end


end
