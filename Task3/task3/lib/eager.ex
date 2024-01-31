defmodule Eager do

  def eval_expr({:atm, id}, _) do {:ok, :a} end
  def eval_expr({:var, id}, env) do
    case env.lookup(id) do
      nil -> :error
      {_, str} -> {:ok,str}
      end
  end
  def eval_expr({:cons, e1, e2}, env) do
    case eval_expr(e1, env) do
      :error -> :error
      {:ok, s1} ->
        case eval_expr(e2, env) do
          :error -> :error
          {:ok, s2} -> {:ok, {s1, s2}}
        end
      end
    end


    def eval_match(:ignore, e1, e1) do
      {:ok, e1}
      end
    def eval_match({:atm, id}, e1, e1) do
      {:ok, e1}
    end

  end






defmodule Env do
  def new do [] end
  def add(id, str, []) do [{id, str}] end
  def add(id, str, [{curr_id, curr_str} | t]) when id < curr_id do [{id, str} | [{curr_id, curr_str} | t]]end
  def add(id, str, [{curr_id, _} | t]) when id == curr_id do [{id, str} | t] end
  def add(id, str, [current | t]) when id > elem(current, 0) do [current | add(id, str, t)] end

  def lookup(_, []) do nil end
  def lookup(id, [{id, str}|_]) do {id, str} end
  def lookup(id, [_|t]) do lookup(id, t) end

  #ids list needs to be sorted
  def remove([], env) do env end
  def remove(_,[]) do [] end
  def remove([id|rest], [{id,_}|tail]) do remove(rest, tail) end
  def remove([id|rest], [{env_id,str}|tail]) when id < env_id do remove(rest, [{env_id,str}|tail]) end
  def remove(ids, [_, tail]) do remove(ids, tail) end

end
