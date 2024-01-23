# Lecture 2
    För stora applikationer så är statiskt typade språk att föredra.

    tuple är en datastrukutur, likt en array men ej typ definierad.
    elixir modul: Gurka.bar(67) -> Alias: gurka egentligen en atom.
    Modulnamn med stor bokstav, erlang med :math tex

    VL är mönster HL är expr. Mönster används även inom parametrarna på funktioner.
# scopes
    Konstigt,  om man använder case och vill komma åt arg2 så måste amn skriva ^varnamn i elixir.

# Immutable
    Funktioner som set and put finns men eftersom datastrukturen inte ändras så kan bara skapa nya liknande.
    En datastruktur som finns som en referns pekar på kommer aldrig ändras. Om den gamla refensen till den datastrukturen ändras så lever datastrukturen kvar i den nya och ändras ej.

# Listor
    Mönster matchning måste matchas korrekt, vid stora mönster där man kanske vill komma åt bara första så kan listor användas. Listor är av typen singly linked.
    foo = 1,
    rest = [2,3,4,5]
    all = [foo | rest]
    all=> [1,2,3,4,5]

    För att plocka ut första värdet kan vi mönstermatcha 
    [head | tail ] = all
    head => 1
    tail => [2,3,4]

    konstant tid på att lägga till i början
    linjär tid att lägga på i slutet eftersom vi måste skapa listan på nytt

    # Att summera talen i en lists
        def sum([]) do 0 end
        def sum([h|t]) do 
            h + sum(t)
        
        alt
        def sam(list) do 0 end
            case list do
                [] -> 0
                [h|t] -> h+sum(t)
            end
        end

# String
    text = "This is a string"
    i erlang är en string en lista av länkade chars
    i elixir är en string en binär grupp, typ men för att jobba med en string så används en liststruktur.

    OM man anger en lista med endast ASCII relaterade siffror så kommer elixir shellet returnet det bokstäver.

    IEx.configure(inspect: [.................]) 

    concatination is odne with <>

    x = "hello " <> "world"

# Parsing
    Två steg, 
    steg 1: lexicak scanner/ tokenizer
    Identifiera tokens: för oss nummer, variabler och expr

    steg 2: identifiera gramattiskla regler.

    expr ::= number | variable | expr plus expr | expr times expr | expr exp expr   
    detta parsears till vårt AST (abstract syntax tree)

    Elixir: leex/yecc

    tokenizirs.xrl 
    Refinitions.
    NUM     = [0-9]+
    VAR     = [a-z]
    EXP     = \^


    Rules.
    regler för hur tokens ska tolkas


    parser.yrl


    :leex.file('toxinzier.xlr')