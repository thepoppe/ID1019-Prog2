# make.exs

Code.compile_file("naive/chopsticks.ex")
Code.compile_file("naive/dinner.ex")
Code.compile_file("naive/philosopher.ex")

Code.compile_file("ref/ref_phil.ex")
Code.compile_file("ref/ref_dinner.ex")
Code.compile_file("ref/ref_chop.ex")

Code.compile_file("simple/simple_chop.ex")
Code.compile_file("simple/simple_dinner.ex")
Code.compile_file("simple/simple_phil.ex")

Code.compile_file("async/async_chop.ex")
Code.compile_file("async/async_dinner.ex")
Code.compile_file("async/async_phil.ex")

Code.compile_file("bench.ex")
