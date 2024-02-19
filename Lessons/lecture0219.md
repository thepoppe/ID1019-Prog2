# CONCURRENCY
DEF två delar som amarabetar
concurrency - hur beskrivs programmet ur en programmatisk synvinkel
    sequential -> concurrent
parallelism -  hårdvaru implementetationen
    sequential -> parallel

OM vi har två processer tex 2 sensorer så är det smart att dela upp i två "oberoende" system som pratar med varandra. DVS två trådar.
Om vi byggt upp en concurrent lösning så delar erlnag upp det bland processorns olika trådar. 

# MODELS - TWO MAJOR
# Shared Memory
shared memory, två trådar delar på minnet som c/cpp och java.
UPP TILL PROGRAMMERAREN att se till att lås sätts på det som inte får fördras

# Message passing
processes sends messages to eachother
ERlang/ELixir
Go
Scala
Rust


CSP skickar till en kanal men vet inte underliggande process-
Go, Rust, Occam
Actor model - skicakr till en process
elixir, scala

# Actor
state: spara et stat som bara kan ändras av accto
recieve: har bara en kanal
execute: 
        send: actor kan skicka medelanden till andra actors
        spawn: skapa nya actors
        transform: förändra sitt state och fortsätta eller stänga ned

Hur håller man koll på meddelanden?


# EXceptions
INdeterminism - hru länge kan vi vänta på nått? 


# PROCESS IDENTIFIER
En datastrukutr som endast används för att identiferea en process.
I elixir så är en process en funktion spawn.

ppid = spawn(fn() -> ...)
Vad funktioner returnerar spelar ingen roll.

send is used to send a message. in erlang a bang operator is used pid!
send(pid, msg)

Expression is  extended <expression> ::= <receive extrepession> | ...
        <recieve expression> ::= 

    def proc() do
        recieve do 
            :some -> do something; proc()
            _ -> dosomethingelse; proc()
        end
    end
När en funktion har reviece do stängs den inte ned, den väntar på ett meddelande. obs rekursiv proc gör att den inte stänger ned.

OBS viktigt att det inte kommer några felmeddelanden om processen är stängd.

pid = spawn(fn -> Test.proc() end)
send(pid, something)



# ex
def server(sum) do
    case -- do
    {:add, num} -> server(sum+num)
    {:sub, num} -> server(sum-num)


self() - gives the pid of this process


# deadlock
när vi fastnar mellan två processer där de väntar på varandra

# filosofer

varje filosof motsvara en process. Uppkommer deadlocks där varje filosof har precis en pinne och inte kan fortsätta.


# felaktiga meddelanden
can catchas med en "catch all" clause.

# KÖN
kön är av typ unreliable FIFO
dvs den bibehåller ordningen men det är inte säkert att meddelandena kommer fram.
Det är processens som har rollen att kontrollera att de meddelanden som måste komma fram kommer fram.
INget problem på lokal maskin men i större system.

SELECTIVE RECIEVE betyder att case satsen bestämmer om jag vill hämta värdet ur kön.


# FSM - finite state machine
node                        switch
---------{:new, n}-----------
                con
                 -------------
