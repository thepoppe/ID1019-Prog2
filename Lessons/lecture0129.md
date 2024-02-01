# EXPRESSIONS
    I derivata uppgiften så använde vi AST för att beskriva olika expressions. I ett programmeringsspråk så används BNF.
    Hur beskrivs semantiken? med definitior på vad saker är för nått.
    <något> ::= hur det uttrycks

    ett minimalt språk
    <atom> ::= :a|:b|:c|...
    <variable> ::= x|y|z|...
    <literal> ::= <atom>
    <expression> ::= <literal>|<variable>| '{' <expression> ',' <expression> '}'

    ex. {:a,:b}, {x,y}, {:a,{:b,z}}

# PATTERNS / MÖNSTER
    väldigt likt terms vilket är enkla expressions men betydelsen är olika.
    En mängd med mönster
    <pattern> ::=   <litteral>
                    |<variable>
                    |'_'
                    |'{'<pattern> ',' <pattern> '}'

# SEQUENCE
    <match> ::= <pattern> '=' <expression>
    <sequence> ::= <expression>
                | <match> ';' <sequence>
    ex x=a; {:b,x} => {:b,:a}

# EVALUERING
    Resultatet av en evaluering ska vara en datastruktur.
    en funktion från "mönster mängden" till en en ny mängd med datastrukturer.

    Atoms = {a,b,c,...}

    Structures = AToms U {{s1ms2}|Structures}
        WE want anothre thing for the errors.
    
    for each atom theres a datastructure s
    a↦s

    A sequence is evaluated given an environment written σ ( SIGMA)
    omgivning, givet en 
    Eσ(e)

    ex.    prerequisite
        Eσ(expression) -> s

# EVALUATION OF EXPRESSION

    ex1.    eval av en atom
            a↦s
          Eσ(a) -> s

    ex2.    eval av en var
            v/s↦σ
          Eσ(v) -> s

    ex3.    Sammansatt struktur
        Eσ(e1)->s1   Eσ(e2)->s2
           Eσ({e1,e2})->



# Evalueringsträd

    :foo -> foo                         blaa
   E{x/bar}(:foo) -> foo        mer blaabalab
            E{x/bar} blablabla 

        v/s not in E

# VAD händer när vi har sekvenser
    x=:a; y=

    EN regel P

    Pσ(p,s) -> θ en ny omgivning

    match an atom           a -> s
                        Pσ (a,s) -> σ

    Match an unbound var    v/t not in σ        finns inget t så att
                        Pσ(v,s) -> {v/s} U σ

    Match an bound var      

            

    Mönster matchning kan ge "fail" not the same as error. matherror instead of compilerror
            a !-> s
        Pσ(a,s) -> fail

        v/t in σ    t !kongruent s
        Pσ

# VARFÖR VI GÖR DETTA
    Kursen lär ut grunderna till funktionell programmering 


# FOR higher grade
    CASE konstruktion

    Funktioner
    f = fn(x) -> {x,x} end ; f.(b) ==> {:b, :b}




# INLÄMNING
    Första, evaluera uttryck. likt första veckan. 
    eval({:add, {:var, :x}, {:num, 5}}, %{:x=>2})





    HÖGRE BETYG
            cons = tuple
    "{:a,:b}" => {:cons, {:atm,:a}, {:atm,:b}} 
    def eval({:atm,})


    def eval ({:cons, e1,e2}, env) do
        case eval(e1,env) do
        {:ok,s1} ->
            case eval(e2, env) do
            {:ok, s2} ->
                {:ok, {s1,s2}}
            :error -> :error
            end
        :error -> :error
        end
    end