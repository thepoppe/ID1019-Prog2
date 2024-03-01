defmodule Eager do
  @type thing :: any
  @type atm :: {:atm, atom}
  @type variable :: {:var, atom}
  @type cons :: {:cons, thing, thing}
  @type env :: [{atom, any}]
  @type ignore :: :ignore
  @type params :: [variable]
  @type free_vars :: [atom]

  @type id :: any #?? id??

  @type expr :: atm | variable | cons | case_ | lambda | apply
  @type pattern :: atm | variable | cons | ignore
  @type match :: {:match, pattern, expr}
  @type sequence :: [expr] | [match|expr]
  @type case_ :: {:case, expr, [clause]}
  @type clause :: { pattern, [expr]}

  @type lambda :: {:lambda, params, free_vars, sequence}
  @type closure :: {:closure, params, sequence, env}
  @type apply :: {:apply, expr, params}

  @type fun :: {:fun, id}

  @spec eval_expr(expr, env) :: :error | {:ok, any}
  def eval_expr({:atm, id}, _) do {:ok, id} end
  def eval_expr({:var, id}, env) do
    case Env.lookup(id,env) do
      nil -> :error
      {_, str} -> {:ok, str}
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
  #CASES
  def eval_expr({:case, expr, clauses}, env) do
    case eval_expr(expr, env) do
      :error -> :error
      {:ok, res} -> eval_cls(clauses, res, env)
    end
  end
  #LAMBDA
  def eval_expr({:lambda, param, free, seq}, env) do
    case Env.closure(free, env) do
      :error -> :error
      closure -> {:ok, {:closure, param, seq, closure}}
    end
  end
  #APPLY
  def eval_expr({:apply, expr, args}, env) do
    case eval_expr(expr, env) do
    :error -> :error
    {:ok, {:closure, par, seq, closure}} ->
      case eval_args(args, env) do # here we evaluate the second param args as they may contain a var
        :error -> :error
        {:ok, str} ->
          updated = Env.args(par, str, closure)
          eval_seq(seq, updated)
      end
    end
  end


  @spec eval_match(pattern, expr, env) :: :fail | {:ok, env}
  def eval_match(:ignore, _, env) do {:ok, env} end
  def eval_match({:atm, id}, id, env) do {:ok, env} end
  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
      nil -> {:ok, Env.add(id, str, env) }
      {_, ^str} -> {:ok, env}
      {_, _} -> :fail
    end
  end
  def eval_match({:cons, head, tail}, {first, second} , env) do
    case eval_match(head , first , env) do
      :fail -> :fail
      {:ok, env} -> eval_match(tail ,second ,env)
    end
  end
  def eval_match(_, _, _) do :fail end


  #SEQUENCES
  @spec extract_vars(pattern, []) :: [variable]
  def extract_vars([], list) do Enum.sort(list) end
  def extract_vars({:atm, _}, list) do Enum.sort(list) end
  def extract_vars({:var, v}, list) do Enum.sort( [v|list])  end
  def extract_vars({:cons, first, second}, list) do
    Enum.sort(extract_vars(second, extract_vars(first, list)))
  end

  @spec eval_scope(pattern, env) :: env
  def eval_scope(pattern, env) do Env.remove(extract_vars(pattern, []), env) end

  @spec eval_seq([expr], env()) :: :error | {:ok, env()}
  def eval_seq([exp], env) do eval_expr(exp, env) end
  def eval_seq([{:match, pattern, expr} | rest], env) do
    case eval_expr(expr, env) do
      :error -> :error
      {:ok, res} ->
        updated = eval_scope(pattern, env)
        case eval_match(pattern, res, updated) do
          :fail -> :error
          {:ok, new_env} ->  eval_seq(rest, new_env)
        end
    end
  end


  #CASES
  @spec eval_cls([clause], expr, env) :: :error | {:ok, env}
  def eval_cls([], _, _) do :error end
  def eval_cls([{:clause, pattern, seq} | cls], expr, env) do
    env =  eval_scope(pattern, env)
    case eval_match(pattern, expr, env) do
      :fail -> eval_cls(cls, expr, env)
      {:ok, new_env} ->eval_seq(seq, new_env)
    end
  end

  #LAMBDA
  @spec eval_args([any], env) :: :error | [any]
  def eval_args(args, env) do eval_args(Enum.sort(args), env, []) end

  @spec eval_args([expr], env, []) :: :error | {:ok, []}
  def eval_args([], _, list) do {:ok, list} end
  def eval_args([arg|args], env, list) do
    case eval_expr(arg, env) do # WHY EVAL_EXPR
      :error -> :error
      {:ok, res} ->  eval_args(args, env, [res | list])
    end
  end
  def eval_args(_, _, _) do :error end
end


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
  def remove([id|rest], [{id,_}|tail]) do remove(rest, tail) end
  def remove([id|rest], [{env_id,str}|tail]) when id < env_id do remove(rest, [{env_id, str}|tail]) end
  def remove(_, env) do env end


  @spec closure([atom], env) :: env | :error
  def closure([], env) do env end
  def closure(vars, env) do
    closure(Enum.sort(vars), env, [])
  end

  @spec closure([atom], env, env) :: env | :error
  def closure([], _, new) do new end
  def closure(_, [], _) do :error end
  def closure([var|vars], [{var, val} | rest ], new) do
    closure(vars, rest, Env.add(var, val, new)) end
  def closure(vars, [_| rest], new) do closure(vars, rest, new) end


  @spec args([atom()], list(), any()) :: any()
  def args([], [], closure) do  closure end
  def args([param |rest], [str|tail], closure) do
     args(rest, tail, Env.add(param, str, closure))
   end

end
