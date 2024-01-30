defmodule Task3 do
  @moduledoc """
  Evaluating an expression
  """
  @type expr() :: {:add, expr(), expr()}
  | {:sub, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:div, expr(), expr()}
  | literal()
  @type literal() :: {:num, number()}
  | {:var, atom()}
  | {:q, number(), number()}

  def main(expr, env) do
    ans = eval(expr, env)
    ans = pprint(ans)
    {:ok, ans}
  end


  def eval({:num, n}, _) do {:ok, n} end
  def eval({:q, n1,n2}, _) do div(n1, n2) end
  def eval({:var, v}, env) do Map.fetch(env, v) end
  def eval({:add, e1, e2}, env) do
    case eval(e1, env) do
      :error -> {:error, "#{pprint(e1)} not found"}
      {:ok, s1} ->
        case eval(e2, env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:ok, s2} -> add(s1, s2)
          _ -> #e2 is rational
            add_rational(s1, e2)
        end
      _ -> #e1 is rational
        case eval(e2,env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:ok, s2} -> add_rational(e1, s2)
           _ -> add_rational(e1,e2)
        end
    end


    #add(eval(e1, env), eval(e2, env))
  end
  def eval({:sub, e1, e2}, env) do
    case eval(e1, env) do
      :error -> {:error, "#{pprint(e1)} not found"}
      {:ok, s1} ->
        case eval(e2, env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:ok, s2} -> sub(s1, s2)
          _ -> #e2 is rational
            sub_rational(s1, e2)
        end
      _ -> #e1 is rational
        case eval(e2,env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:ok, s2} -> sub_rational(e1, s2)
           _ -> sub_rational(e1,e2)
        end
    end
    #sub(eval(e1, env), eval(e2, env))
  end
  def eval({:mul, e1, e2}, env) do
    case eval(e1, env) do
      :error -> {:error, "#{pprint(e1)} not found"}
      {:ok, s1} ->
        case eval(e2, env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:ok, s2} -> mul(s1, s2)
          _ -> #e2 is rational
            mul_rational(s1, e2)
        end
      _ -> #e1 is rational
        case eval(e2,env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:ok, s2} -> mul_rational(e1, s2)
           _ -> mul_rational(e1,e2)
        end
    end
    #mul(eval(e1, env), eval(e2, env))
  end
  def eval({:div, e1, e2}, env) do
    case eval(e1, env) do
      :error -> {:error, "#{pprint(e1)} not found"}
      {:ok, s1} ->
        case eval(e2, env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:ok, s2} -> div(s1, s2)
          _ -> #e2 is rational
            div_rational(s1, e2)
        end
      _ -> #e1 is rational
        case eval(e2,env) do
          :error -> {:error, "#{pprint(e2)} not found"}
          {:ok, s2} -> div_rational(e1, s2)
           _ -> div_rational(e1,e2)
        end
    end
  #div_(eval(e1, env), eval(e2, env))  end
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
    {:ok, e1/e2}
    else
      {:q, e1, e2}
    end
  end
  def div_(e1, e2) do
    div_rational(e1, e2)
  end

  def add_rational({:q, r1, r2}, {:q, r3, r2}) do {:q, r1+r3, r2} end
  def add_rational({:q, r1, r2}, {:q, r3, r4}) do {:q, (r1*r4)+(r2*r3), (r2*r4)} end
  def add_rational(e1, {:q, r1, r2}) do {:q, (e1*r2)+ r1, r2} end
  def add_rational({:q, r1, r2}, e1) do {:q, (e1*r2)+ r1, r2} end

  def sub_rational({:q, r1, r2}, {:q, r3, r2}) do {:q, r1-r3, r2} end
  def sub_rational({:q, r1, r2}, {:q, r3, r4}) do {:q, (r1*r4)-(r2*r3), r2*r4} end
  def sub_rational(e1, {:q, r1, r2}) do {:q, (e1*r2)-r1, r2} end
  def sub_rational({:q, r1, r2}, e1) do {:q, (e1*r2)-r1, r2} end

  def mul_rational({:q, r1, r2}, {:q, r3, r4}) do {:q, r1*r3, r2*r4} end
  def mul_rational(n1, {:q, r1, r2}) when rem(n1, r2) == 0 do {:q, r1, div(n1, r2)} end
  def mul_rational(n1, {:q, r1, r2})  do {:q, r1*n1, r2} end

  def mul_rational( {:q, r1, r2}, n1) when rem(n1, r2) == 0 do {:q, r1, div(n1, r2)} end
  def mul_rational({:q, r1, r2}, n1)  do {:q, r1*n1, r2} end

  def div_rational({:q, r1, r2}, {:q, r3, r4}) do {:q, r1*r4, r2*r3} end
  def div_rational(n1, {:q, r1, r2}) do {:q, n1*r2, r1} end
  def div_rational({:q, r1, r2}, n1) do {:q, r1, r2*n1} end

  def pprint({:ok, num}) do "#{num}" end
  def pprint({:var, v}) do "#:#{v}" end
  def pprint({:q, n1, n2}) do "#{n1}/#{n2}" end
  def pprint({:error, msg}) do ":error, #{msg}" end
  def pprint(:error) do ":error, expression could not be evaluated" end
  def pprint(rest) do "#{rest}" end

end
