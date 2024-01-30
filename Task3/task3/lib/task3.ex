defmodule Task3 do
  @moduledoc """
  Evaluating an expression
  """
  @type expr() :: {:add, expr(), expr()}
  | {:sub, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:div_, expr(), expr()}
  | literal()
  @type literal() :: {:num, number()}
  | {:var, atom()}
  | {:q, number(), number()}

  def main(expr, env) do
    {status, ans} = eval(expr, env)
    {status, pprint(reduce(ans))}
  end


  def eval({:num, n}, _) do {:ok, n} end
  def eval({:q, n1,n2}, _) do div_(n1, n2) end
  def eval({:var, v}, env) do Map.fetch(env, v) end
  def eval({:add, e1, e2}, env) do
    case eval(e1, env) do
      :error -> {:error, "#{pprint(e1)} not found"}
      {:error, e} -> {:error, e}
      {:ok, s1} ->
        case eval(e2, env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:error, e} -> {:error, e}
          {:ok, s2} -> add(s1, s2)
          {:rational, s2} -> #e2 is rational
            add_rational(s1, s2)
        end
      {:rational, s1} -> #e1 is rational
        case eval(e2,env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:error, e} -> {:error, e}
          {:ok, s2} -> add_rational(e1, s2)
          {:rational, s2} -> #e2 is rational
            add_rational(s1, s2)
        end
    end
  end
  def eval({:sub, e1, e2}, env) do
    case eval(e1, env) do
      :error -> {:error, "#{pprint(e1)} not found"}
      {:error, e} -> {:error, e}
      {:ok, s1} ->
        case eval(e2, env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:error, e} -> {:error, e}
          {:ok, s2} -> sub(s1, s2)
          {:rational, s2} -> #e2 is rational
            sub_rational(s1, s2)
        end
      {:rational, s1} -> #e1 is rational
        case eval(e2,env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:error, e} -> {:error, e}
          {:ok, s2} -> sub_rational(s1, s2)
          {:rational, s2} -> #e2 is rational
            sub_rational(s1, s2)
        end
    end
  end
  def eval({:mul, e1, e2}, env) do
    case eval(e1, env) do
      :error -> {:error, "#{pprint(e1)} not found"}
      {:error, e} -> {:error, e}
      {:ok, s1} ->
        case eval(e2, env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:error, e} -> {:error, e}
          {:ok, s2} -> mul(s1, s2)
          {:rational, s2} -> #e2 is rational
            mul_rational(s1, s2)
        end
      {:rational, s1} -> #e1 is rational
        case eval(e2,env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:error, e} -> {:error, e}
          {:ok, s2} -> mul_rational(s1, s2)
          {:rational, s2} -> #e2 is rational
            mul_rational(s1, s2)
        end
    end
  end
  def eval({:div, e1, e2}, env) do
    case eval(e1, env) do
      :error -> {:error, "#{pprint(e1)} not found"}
      {:error, e} -> {:error, e}
      {:ok, s1} ->
        case eval(e2, env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:error, e} -> {:error, e}
          {:ok, s2} -> div_(s1, s2)
          {:rational, s2} -> #e2 is rational
            div_rational(s1, s2)
        end
      {:rational, s1} -> #e1 is rational
        case eval(e2,env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:error, e} -> {:error, e}
          {:ok, s2} -> div_rational(s1, s2)
          {:rational, s2} -> #e2 is rational
            div_rational(s1, s2)
        end
    end
  end

  def add(e1, e2) do
    if(is_integer(e1) && is_integer(e2)) do
      {:ok, e1+e2}
    else
      add_rational(e1, e2)
    end
  end

  def sub(e1, e2) do
    if(is_integer(e1) && is_integer(e2)) do
      {:ok, e1-e2}
    else
      sub_rational(e1, e2)
    end
  end

  def mul(e1, e2) do
    if(is_integer(e1) && is_integer(e2)) do
      {:ok, e1*e2}
    else
      mul_rational(e1, e2)
    end
  end
  def div_(e1, e2) when is_integer(e1) and is_integer(e2) do
    if rem(e1,e2) == 0 do
    {:ok, div(e1,e2)}
    else
      {:rational, {:q, e1, e2}}
    end
  end
  def div_(e1, e2) do
    div_rational(e1, e2)
  end

  def add_rational({:q, r1, r2}, {:q, r3, r2}) do div_(r1+r3, r2) end
  def add_rational({:q, r1, r2}, {:q, r3, r4}) do div_((r1*r4)+(r2*r3), (r2*r4)) end
  def add_rational(e1, {:q, r1, r2}) do div_((e1*r2)+ r1, r2) end
  def add_rational({:q, r1, r2}, e1) do div_((e1*r2)+ r1, r2) end

  def sub_rational({:q, r1, r2}, {:q, r3, r2}) do div_(r1-r3, r2) end
  def sub_rational({:q, r1, r2}, {:q, r3, r4}) do div_((r1*r4)-(r2*r3), r2*r4) end
  def sub_rational(e1, {:q, r1, r2}) do div_((e1*r2)-r1, r2) end
  def sub_rational({:q, r1, r2}, e1) do div_((e1*r2)-r1, r2) end

  def mul_rational({:q, r1, r2}, {:q, r3, r4}) do div_(r1*r3, r2*r4) end
  def mul_rational(n1, {:q, r1, r2}) when rem(r1, n1) == 0 do div_( r1, div(r2, n1)) end
  def mul_rational(n1, {:q, r1, r2})  do div_( r1*n1, r2) end

  def mul_rational( {:q, r1, r2}, n1) when rem(r2, n1) == 0 do div_(r1, div(r2, n1)) end
  def mul_rational({:q, r1, r2}, n1)  do div_(r1*n1, r2) end

  def div_rational({:q, r1, r2}, {:q, r3, r4}) do div_(r1*r4, r2*r3) end
  def div_rational(n1, {:q, r1, r2}) do div_(n1*r2, r1) end
  def div_rational({:q, r1, r2}, n1) do div_(r1, r2*n1) end


  def reduce({:q, top, bot}) when rem(top,2) == 0 and rem(bot,2) == 0 do reduce({:q, div(top,2), div(bot,2)}) end
  def reduce({:q, top, bot}) when rem(top,3) == 0 and rem(bot,3) == 0 do reduce({:q, div(top,3), div(bot,3)}) end
  def reduce({:q, top, bot}) when rem(top,5) == 0 and rem(bot,5) == 0 do reduce({:q, div(top,5), div(bot,5)}) end
  def reduce({:q, top, bot}) when rem(top,7) == 0 and rem(bot,7) == 0 do reduce({:q, div(top,7), div(bot,7)}) end
  def reduce(literal) do literal end

  def pprint({:ok, num}) do "#{num}" end
  def pprint({:var, v}) do ":#{v}" end
  def pprint({:q, n1, n2}) do "#{n1}/#{n2}" end
  def pprint({:error, msg}) do "error, #{msg}" end
  def pprint(:error) do ":error, expression could not be evaluated" end
  def pprint(rest) do "#{rest}" end

end
