defmodule Env do
  @type env :: [{key, value}]
  @type key :: atom
  @type value :: any

  def new do [] end
  @spec add(atom, value, env) :: env
  def add(id, str, []) do [{id, str}] end
  def add(id, str, [{curr_id, curr_str} | t]) when id < curr_id do [{id, str} | [{curr_id, curr_str} | t]]end
  def add(id, str, [{curr_id, _} | t]) when id == curr_id do [{id, str} | t] end
  def add(id, str, [current | t]) when id > elem(current, 0) do [current | add(id, str, t)] end

  @spec lookup(atom, env) :: nil | {atom, value}
  def lookup(_, []) do nil end
  def lookup(id, [{id, str}|_]) do {id, str} end
  def lookup(id, [_|t]) do lookup(id, t) end

  #ids list needs to be sorted
  @spec remove([atom()], env) :: env
  def remove([], env) do env end
  def remove(_,[]) do [] end
  def remove([id|rest], [{id,_}|tail]) do remove(rest, tail) end
  def remove([id|rest], [{env_id,str}|tail]) when id < env_id do remove(rest, [{env_id, str}|tail]) end
  def remove(ids, [_, tail]) do remove(ids, tail) end

  @spec closure([atom], env) :: env
  def closure(free_var, env) do
    closure(Enum.sort(free_var), env, [])
  end

  @spec closure([atom], env, env) :: env
  def closure([], _, new_env) do new_env end
  def closure(_, [], _) do :error end
  def closure([var|rest], [{var, value}|tail], new_env) do closure(rest, tail, Env.add(var, value, new_env)) end
  def closure(vars, [_|tail], new_env) do closure(vars, tail, new_env) end

end
