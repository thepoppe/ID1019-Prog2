# lambda kalkylen
Reducerad matematisk semantik.
funktion inuti funktioner

# ett väldigt litet språk
domain, Z 
primitiva funktioner +,-,*,mod,div

eval: (3+5)*(6-3) 
strikta funktioner = om ett av argumenten ger bottoms så ger funktionen bottoms.
OM alla funktioner är strikta så måste alla arguments evalueras. Här spelar ordningen ingen roll.

if , then else är icke strikt eftersom vi evaluerar och gör något  och om det är falskt så gör vi else.

Introducerar variabler och functions
x,y
λ x  -> x+5
(λ x->x+5) 7     ---- (λx <E>)7 <=> [x/7]<E> applicerar 7 på funktionen.
[x/7]<x+5>  7+5
[x/7]<>

# scope of declarations
scoping regler, vilket x pratar vi om? 
λx -> (λx -> (x*y))
 b      b     b f
Vi pratar om fria variabler och bunda variabler. bunda är de som är bundna till lambda funktionen.

substitution... [x/<F>]<E> is possible if <F> har 0 free vars

# lambda kalkylen
introducerad av Alonso Church
three types of expresseion. variabler, lambda uttryck, applicering
lamndakalkylen har inga datastrukturer eller namnade funktioner. 
TOM heltal representerars av funktioner.


# funktioner vill ha fler args
vi introducerar fler vars till lambda uttrycket
λx-> (λy-> y) x?
λxy -> x+y

vi vill inte göra om samma op
λx -> (x+2) + (x+2)
λx -> ((λy -> y+y)(x+2))
λx -> let y = 2*(y+2) ???????


# Recursion
lite magiskt, att funktionen anropar sig själv innan den är klar.
y kompilatorn to the rescue... 
def foo do
f = fn x,y,z ->
        case x
            [] -> y
            [h|t] -> [h|g.(t,y,g)]
        end
    end
fn x,y -> f.(x,y,z) end
end


# Funkionella programmeringsspråk
bygger på lambda kalkylen men har ett flertal simplificieringar för att göra det enklare att programmera
namngivna funktioner, datastruktur och fördefinerade  funktioner.

normalordning (EAGER), evaluera argument innan vi gör funktionen

latordning (LAZY), tittar på vad det är för funktion först. OM argumentet behövs så kommer den attt evaluera. Den skulle inte heller utföra en mulitplikation.

