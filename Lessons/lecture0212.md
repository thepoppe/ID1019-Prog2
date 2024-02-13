# Linjära problem? 
    diofantiska ekvationer, linjär algebra med olikheter.
    för att lösa sådana här problem så uppfanns.

    dynamix programming - djupet först sök med hashning
    1: op1|op2
    2: (op1-> op1|op2) | (op2-> op1|op2)

    Vi bygger ett binärt träd med all a möjligheter.
    Djupet på trädet är n/k => O( n * 1/k) = > O(n)
    Hur många noder? 2^n och eftersom vi måste kolla alla så blir det exponentiel tidskomplexitet.

    om vi gör op1 -> op2 så är det samma sak som op2 -> op1
    Vid varje punkt ( "har jag varit här förut och vad var svaret isåfall)
    hur  beskrivs varje punkt? search ( x , y ,_) där x, y beskriver samma punkt

    Detta är veckans uppgift.   
    loopa igenom kolla efter ?   kolla nästa med nytt

    Vi behöver inte komma på något klurigt, vi ska lösa det som ett sök problem. 

    DEL 2: 
    kartan är felaktig, ta allt gånger 5.
    För del 2 så måste vi känna igen vad vi redan sett.

    MEd en cache vad är skilnaden? 
    n är material och tid
    djupet är n/k, ordo n på minnet vilket get en kvadrastisk komponent



# REPRESENTATION
    {[:op, dam, :unk, :op, :op, :dam], [2,1]}

    def search([:ok| rest, spec], spec) do search(rest, spec) end
    def search([:dmg| rest, [n|spec]], spec) do 
        case damaged(rest, n-1) 
        {:ok,k,rest, restpåspec} -> search(rest, restpåspec) + k
        nil -> nil 
    end

    def search([:unk| rest, spec], spec) do
        Om den är dmg eller inte ska vi undersöka då.