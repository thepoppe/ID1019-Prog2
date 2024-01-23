# funktioner och tomma "omgivningar"
    Man kan få ett mönster utan att veta dess innehåll

    Man kan använda try catch för att "prova". Fördel med funktionell mot tex java (proceduellt språk) så kan man fundera på om alla objekt är intakta eller om något ändrades av funktionen som failade.
    I ett funktionellt språk så är datastrukturerna immutable och vi är därför säkra på att dessa strukturer inte är ändrade.

    def foo(x,y) do
        try do 
            {:ok, bar(x,7)}
        rescue
            error->{:error,error}
        end
    end

# Listor - append
    def append([], y ) do y end
    def append([h|t], y) do 
        z = appends(t, y)
        [h|z]
    end

    mönstermatcha mot en tom lista för ett basecase. om listan inte är tom så lägger vi till z till 

    '++' = append men dyr not constant time
    [x|y] a constant time 

# Union of multisets
    a multiset  or bag is a aset with duplicated elemets. same value can appear many times.
    union is the same as append. append bibehåller ordning? vid mängder så spelar ordningen ingen roll.

    def tailr([], y) do y end
    def tailr([h|t],y) do
        tailr(t, [h|z])
    end

# Stack - tail recursive code
    When we create results using recursion we put things on the stack thats calculated and pop the stack to the last recursion entry. this way we return the correct values to the calling function.

    The append function does things on both the way "down" and "up" through the recursion while the tailr does all things on the way down. On the way up we just return things. Appends needs to store inforamtion on the next operation to do as well.

    In funcitonal programming, recursion is used a lot and we need to save space. To remember the next instructions compared to just returning things in the "walk up". We dont need to push operations to the stack, when we reach the end we are done and can return the asnwer. tail optimzation doesn not need to be built on the stack.

    append for union with a list of 10 millions element would crash the stack compared. More complex code to avoid exploding the stacks can be necessary depending on the cardinality of the sets.

# accumlators

# n-reverse
    def rev([]) do [] end n^2
    def rev([h|t]) do
        rev(t) ++ [h]
    end


    def rev(1) do rev(1,[]) end -----video n

# queues
    There are no list. since its easy to add to the begining two lists are created
    queues are interesting look up.

# tree 
    leaf: {:leaf, value}

    node: {:nide, value, left, right}

    empty tree: :nil

    We fill the tree from the top with constant time

    To search through a tree base cases, check left if :no check right

    To searh an ordered tree basecases, if n < value -> go left n > value ->go right

    AVL trees, Splay trees to have balanced tree. 

# Key-value lookup - MAP
    ... Assignment