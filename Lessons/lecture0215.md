# COMPLEXITET

# CHOPPING WOOD
    om vi ska dela upp en stock i bitar om
    [3,2,3,1,2]

    steg 1 sortera listan [1,2,2,3,3]
    splittar listan [1,2] & [2,3,3]
        [1,2] = {3 , [1,2]} deras totala längd är 3
        sorterar: [2,{3,[1,2]}, 3,3]

        splittar igen: [2, {3,[1,2]}] & [3,3]
        {5,[2, {3,[1,2]}]} & {6,[3,3]}

        Det bästa sättet att dela upp är i först

        HUFFMAN KOM PÅ DENNA LÖSNINGS ALG

# ETT till problem
    {10, [3,5,9]}
    om vi har en 10 meters stock och 3,5,9 representerar olika klipp
    1-3, 3-5, 5-9, 9-10 -> 4 bitar

    MEN OM VI TÄNKER ATT VI KAN VÄLJA såga eller inte vid varje 

                                     {10, [3,5,9]}
                    {10, [3],[,5,9]}             {3, []},{8, [2,6]}
            {10, [3,5],[9]}

    Problemet är hur många element klipplistan består av. antal noder blir 2^n eftersom vi kommer behöva göra två val på n. lite svårt att förstå denna. 

# komplexitet 
    För att beräkna koplexiteten på func med funktioner så måste alla funktioners komlexitet examineras.

    def reverse([], y) do y end
    def reverse([h|t]) do

    n st rekursioner och inuti har vi en konstant operation

    

# Matematisk härledning i komplexitet
    Tn beskriver tiden för att köra en funktion som är n lång-.
    T0 = a ms
    Tn = Tn-1 + k(n-1) + b ms    ,    k=append   b=konstant för att göra operationen.
        = Tn-2 + k(n-2) + k(n-1) + 2b
            = Tn-3 + k(n-3) + k(n-2) + k(n-1) + 3b
                :
                    = Tn-n +k(n-n) + ... + k(n-2) + k(n-1) + nb
                        = a + 0  + k + + 2k + 3k ... (n-1)k + nb 
                        = n* (n-1)/2 * k + nb + a
                        = (k/2)* n^2 - (k/2)* n + bn + a 

DETTA görs normalt bara på en tenta för attt flexa


# Intuiv approach
    Den dåliga reverse med append
        |.....
        |....
        |...
        |..
        |.
n*n/2    -----

    den bra reverse

        .
        .
        .
        .
        .
        n

    quicksort:
    def qsort([]) do [] end
    def qsort([h]) do [h] end
    def qsort(all) do 
        {low, high} = partition(all)
        lowS = qsort(low)
        highS = qsort(high)
        append(lowS, highS)
    end

    T1 = a
    Tn = 2* T(n/2) + nc, nc = konstant tid för partion och append
        = 2* (2* T(n/4)+ (n/2*c)) + nc
        = 4 * (T(n/4) + 2 * nc)
        = 8 * (T(n/8) + 3 * nc)
        :
        = 2^k * T1 + k*nc ,     T1 = T n/n
        = 2^lg(n) * a + lg(n)* nc
        = n*a + lg(n) * n* c

VIsuell
      | ........            n
      | ....|....   
      | ..|..|..|..|
      | .|.|.|.|.|.|.|.|        

log(n)*n   <------>


