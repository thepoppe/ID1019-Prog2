# eager, eval_clause, eval_match
eval_expr ({:case,})

eval cls([],_,) do :error) 

eval_cls([{:cls, p, seq}| clauses], s, env) doo
    eval_match(p,s, scope(p,env)) do     ###### scope söker igenom en "env och ?plockar bort? och returnerar en mindre env
        :fail -> eval_cls( clauses, s , env)
        {:okk, updated_env} -> eval_seq(seq, updated_env)
        end
    end
end


# Representation
befintliga
{:atm, :a}, {:var, :v}, {:cons, ...}, {:case, ...}

f = fn (x) -> {:a, x} end; f.(:b)

[{:match, {:var, :f, ???}, ??? {:atm, :b}}]

Representera en funktion
-------------------------------------------------------------------------------
fn(x) -> y=:a; {y, x} end
  |
parametrar [], [:x], [:x,:z] alla identifierare
            |
   sequence y=:a;{y,x}

{:func, param, seq} kanske?
{:func, [:x], [{:match, {:var,:y}, {:atm, :a}}, {:cons,{:var, :y}, {:var, :x}}]} KANSKE?
-------------------------------------------------------------------------------

lokalt scope inuti funktioner i elixir, vad väljer vi?

f = fn (x) -> x+y end; f.(:b)
f är en funktion med kunskap om vad y är vid tillfället.
DETTA kallas för "closure". Kan ses som att y byts ut mot 6 eller
fn (x) -> x+y  ~{y=6} end    //    fn (x) -> x+6 end


def eval_expr({:fun, param, free, seq}, env) do
    {:closure, param, seq, Env.closure(env, free)} param är en lista av variabel identifierar.  
end                                                                  Closure returnerar en ny env med de fria var


HUR REPRESENTERAR VI...

{:closure, par, seq, clos} -------- KANSKE KONSTIGT NAMN?

f.(:b)
{:apply, {:var,:f}, [{:atm,:b}]}

f är förhoppningsvis en closure???  om f är en :closure så kan vi köra  match f med :closure

def eval_expr({:apply, e, arg}, env) do
    case eval(e) do
    {:closuer, ...} -> # GO AHEAD
     case eval_args(args, env) do
        {:ok, args} ->
            case Env.add_all( par, args closure)
            {:ok, update} ->
                eval(seq, updated) för attt evaluera en sekvens så måste parametrarna mappas till arg? och closure måste med.
            _ -> :error
        :error -> :error
        end
    _ -> :error
    end
end



# Macro systemet i elixir
Det är trist att behöva använda AST till funktionerna. För att lösa detta så  anvädner elixir ett macro system  som konverterar input till ASTsom elixir läser.


