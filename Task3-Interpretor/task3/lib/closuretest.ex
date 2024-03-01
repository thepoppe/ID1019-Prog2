defmodule Test do
  @type env :: [{atom, any}]

  def test() do
    #fn x -> y + x end in env=[y: :nått] ese error
    #closure är hela grejjen

    free_var = [:z, :a]
    env = Env.add(:y, :nått, [])
    env = Env.add(:z, :nåttannat, env)
    env = Env.add(:a, :nåttannatigen, env)
    res = closure(free_var, env)
    {:ok, res}
  end

  def closure(keyss, env) do
    List.foldr(keyss, [], fn(key, acc) ->
      case acc do
        :error ->
          :error

        cls ->
          case lookup(key, env) do
            {key, value} ->
              [{key, value} | cls]

            nil ->
              :error
          end
      end
    end)
  end

  def lookup(key, env) do
    List.keyfind(env, key, 0)
  end

end
