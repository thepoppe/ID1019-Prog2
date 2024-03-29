defmodule Task1 do
 #number: {:num, 123}
 #variabler: {:var, :x}
 #constants: {:var, :pi}
  @type literal() :: {:num, number()} | {:var, atom()}
  #add: {:add, {:num, 1}, {:var, :pi}}
  #mul: {:mul, {:num, 1}, {:var, :pi}}
  @type expr() ::
  {:add, expr(), expr()} |
  {:mul, expr(), expr()} |
  literal() |
  {:exp, expr(),literal()} |
  {:ln, expr()} |
  {:div, expr(), expr()} |
  {:sqrt, expr()} |
  {:sin, expr()}



  #expression kan då representera ett uttryck eftersom en literal är ett uttryck
  #"2 * x + 3" -> {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}} Detta är uttrycket uttryckt i 'expressions'



  #derivera x med avseende på x
  def derive({:var, x}, x) do {:num,1} end
  #derivera konstant med avseende på en variabel
  def derive({:num, _}, _) do {:num,0} end
  #derivera en variabel med avseende på en annan
  def derive({:var, _}, _) do {:num,0} end
  #derivera addition med avsende på x (additionsregeln)
  def derive({:add, f, g}, x) do {:add, derive(f, x), derive(g, x)} end
  #derivera multiplikation med avseende på x (produktregeln)
  def derive({:mul, f, g}, x) do
    {:add,
    {:mul, derive(f, x), g},
    {:mul, derive(g,x), f}}
  end
  #derivera en exponent med avseende på x, ex x^3 (f^n från uppgift)
  def derive({:exp, e, {:num, n}}, x) do
    {:mul,
    {:mul,{:num, n}, {:exp, e, {:num, n-1}}},
    derive(e,x)}
  end
  def derive({:exp, e, {:float, n}}, x) do
    {:mul,
    {:mul,{:float, n}, {:exp, e, {:float, n-1}}},
    derive(e,x)}
  end



  #derivera ln(f(x)) med avseende på x
  def derive({:ln, e}, x) do
    case e do
      #{:num, _} -> {:num, 0}
      #{:var, :x} -> {:div, 1, e}
      #{:var, :_} -> {:num, 0}
      _ -> {:mul, {:div,{:num, 1}, e}, derive(e,x)}
    end
  end



  #derivera sqrt(f(x)) med avseende på x
  def derive({:sqrt, e}, x) do
    derive({:exp, e, {:float, 0.5}}, x)#float needed?
  end


  #derivera 1/f(x) med avseende på x
  #general
  def derive({:div, {:num, 1}, e}, x) do
     derive({:exp, e, {:num, -1}}, x)
  end



  #derivera sin(f(x)) med avseende på x --------------------------NOTDONE--------------------------
  def derive({:sin, e}, x) do
    {:mul, derive(e , x),{:cos, e}}
  end


  #Funktion för att förenkla matematiska uttryck
  def simplify({:add, e1, e2}) do simplify_add(simplify(e1), simplify(e2)) end
  def simplify({:mul, e1, e2}) do simplify_mul(simplify(e1), simplify(e2)) end
  def simplify({:exp, e1, e2}) do simplify_exp(simplify(e1), simplify(e2)) end
  def simplify({:div, e1, e2}) do simplify_div(simplify(e1), simplify(e2)) end
  def simplify(e) do e end
  #helpers for add
  @spec simplify_add(any(), any()) :: any()
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end
#helpers for mul
  def simplify_mul(_, {:num, n}) when n==0 do {:num, 0} end
  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul({:float, f}, {:num, n}) do {:float, f*n} end #-------------------------
  def simplify_mul({:num, n}, {:float, f}) do {:float, f*n} end #-------------------------
  def simplify_mul({:float, n}, {:div, e1, e2}) when n == 0.5 do {:div, e1, {:mul, {:num, 2}, e2}} end #-------------------------
  def simplify_mul({:div, e1, e2}, {:float, n}) when n == 0.5 do {:div, e1, {:mul, {:num, 2}, e2}} end #-------------------------
  def simplify_mul({:num, n1}, {:mul, {:num, n2}, e}) do {:mul, {:num, n1*n2}, e} end
  def simplify_mul({:num, n1}, {:mul, e, {:num, n2}}) do {:mul, {:num, n1*n2}, e} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end
#helpers for exp
  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e, {:num, 1}) do e end # FÖRÄNDRING---------------------------------------------------------------------
  def simplify_exp(e, {:float, n}) when n == 0.5 do {:sqrt, e} end
  def simplify_exp(e, {:float, n}) when n == -0.5 do {:div, {:num,1}, {:sqrt, e}} end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1, n2)} end
  def simplify_exp({:exp, e, {:num, n1}}, {:num, n2}) do {:exp, e, {:num, n1*n2}} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end
#helpers for div
  def simplify_div({:num, 1}, {:var, x}) do {:div, {:num, 1}, {:var, x}} end
  def simplify_div({:var, x}, {:num, 1}) do  {:var, x} end
  def simplify_div(e1, e2) do {:div, e1, e2} end




  #funktion för att förenkla utrskriften
  #{:add, {:add, {:mul, {:num, 0}, {:var, :x}}, {:mul, {:num, 1}, {:num, 2}}},{:num, 0}} som var svaret på 2x+3
  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:mul, {:var, v}, {:num, n}}) do "#{n}#{v}" end
  def pprint({:mul, {:num, n}, {:var, v}}) do "#{n}#{v}" end
  def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
  def pprint({:exp, e, {:num, n}} )when n < 0 do "(1/(#{pprint({:exp, e, {:num, n*-1} })}))" end
  def pprint({:exp, e1, e2}) do "#{pprint(e1)}^#{pprint(e2)}" end
  def pprint({:ln, e}) do "ln(#{pprint(e)})" end
  def pprint({:div, 1, e2}) do "1/(#{pprint(e2)})" end
  def pprint({:div, e1, e2}) do "#{pprint(e1)}/(#{pprint(e2)})" end
  def pprint({:sqrt, e}) do "sqrt(#{pprint(e)})" end
  def pprint({:float, f}) do "#{f}" end #------------------------------------------
  def pprint({:sin, e}) do "sin(#{pprint(e)})" end
  def pprint({:cos, e}) do "cos(#{pprint(e)})" end

  #funktioner för att räkna ut
  def calc( {:num, n}, _, _) do {:num, n} end
  def calc( {:var, v}, v, n) do {:num, n} end
  def calc( {:var, v}, _, _) do {:var, v} end
  def calc( {:add, e1, e2}, v, n) do {:add, calc(e1, v, n), calc(e2, v, n)} end
  def calc( {:mul, e1, e2}, v, n) do {:mul, calc(e1, v, n), calc(e2, v, n)} end
  def calc( {:exp, e1, e2}, v, n) do {:exp, calc(e1, v, n), calc(e2, v, n)} end


  def io_write_expr(e1, e2) do
    IO.write("Expression: #{pprint(e1)}\n")
    IO.write("Derivative: #{pprint(e2)}\n")
    IO.write("Simplified: #{pprint( simplify(e2) )}\n")
    IO.write("\n")
    :ok
  end

  def io_write_expr(e1, e2, e3) do
    IO.write("Expression: #{pprint(e1)}\n")
    IO.write("Derivative: #{pprint(e2)}\n")
    IO.write("Simplified: #{pprint( simplify(e2) )}\n")
    IO.write("Calculated: #{pprint( simplify(e3) )}\n")
    IO.write("\n")
    :ok
  end

  #Vi kör ett test på 2x + 3 från innan.
  #Expected result 2 ->
  def test1() do
    e = {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}
    d = derive(e, :x)
    c = calc(d, :x, 5)
    io_write_expr(e, d, c)
    :ok
  end


  #provar ett uttryck med en exponent x^3 + 4 -> 3x^2
  def test2() do
    e = {:add, {:exp, {:var, :x}, {:num, 3}}, {:num, 4}}
    d = derive(e, :x)
    c = calc(d, :x, 4)
    io_write_expr(e, d, c)
    :ok
  end

  #provar derivera ln(x) funkar inte för x+1
  def test_ln() do
    e1 = {:ln, {:var, :x}}
    d1 = derive(e1, :x)
    io_write_expr(e1, d1)

    e2 = {:ln, {:num, 2}}
    d2 = derive(e2, :x)
    io_write_expr(e2, d2)

    e3 = {:ln, {:var, :c}}
    d3 = derive(e3, :x)
    io_write_expr(e3, d3)

    e4 = {:ln,{:mul, {:num,2}, {:var, :x}}}
    d4 = derive(e4, :x)
    io_write_expr(e4, d4)

    e5 = {:ln, {:add, {:var, :x}, {:num, 3}}}
    d5 = derive(e5, :x)
    io_write_expr(e5, d5)
    :ok
  end

  def test_sqrt() do
    e1 = {:sqrt, {:var, :x}}
    d1 = derive(e1, :x)
    io_write_expr(e1, d1)

    e2 = {:sqrt, {:num, 1}}
    d2 = derive(e2, :x)
    io_write_expr(e2, d2)

    e3 =  {:sqrt, {:var, :c}}
    d3 = derive(e3, :x)
    io_write_expr(e3, d3)

    e5 = {:sqrt,{:mul, {:num,2}, {:var, :x}}}
    d5 = derive(e5, :x)
    io_write_expr(e5, d5)

    e4 = {:sqrt, {:add, {:var, :x}, {:num, 3}}}
    d4 = derive(e4, :x)
    io_write_expr(e4, d4)
    :ok
  end

  def test_div() do
    e1 = {:div, {:num, 1}, {:var, :x}}
    d1 = derive(e1, :x)
    io_write_expr(e1, d1)

    e2 = {:div, {:num, 1}, {:mul, {:num,2}, {:var, :x}}}
    d2 = derive(e2, :x)
    io_write_expr(e2, d2)

    e3 = {:div, {:num, 1}, {:add, {:num,1}, {:var, :x}}}
    d3 = derive(e3, :x)
    io_write_expr(e3, d3)

    e4 = {:div, {:num, 1}, {:exp, {:var, :x}, {:num, 2}}}
    d4 = derive(e4, :x)
    IO.write("Expression: #{pprint(e4)}\n")
    IO.write("Derivative: #{pprint(d4)}\n")
    IO.write("Simplified: #{pprint( simplify(d4) )}\n") #not working
    IO.write("\n")
    :ok
  end


  def test_sin() do
    e1 = {:sin, {:var, :x}}
    d1 = derive(e1, :x)
    io_write_expr(e1, d1)

    e2 = {:sin, {:mul, {:num,2}, {:var, :x}}}
    d2 = derive(e2, :x)
    io_write_expr(e2, d2)

    e3 = {:sin, {:add, {:num,1}, {:var, :x}}}
    d3 = derive(e3, :x)
    io_write_expr(e3, d3)

    e4 = {:sin, {:exp, {:var, :x}, {:num, 2}}}
    d4 = derive(e4, :x)
    IO.write("Expression: #{pprint(e4)}\n")
    IO.write("Derivative: #{pprint(d4)}\n")
    IO.write("Simplified: #{pprint( simplify(d4) )}\n") #not working
    IO.write("\n")
    :ok
  end

  def test_final() do
    e1 =
            {:exp,
              {:sin,
                {:mul, {:num, 2}, {:var, :x}}},
              {:num,-1}}
    e1 =  {:div,
              {:num, 1},
                {:sin , {:mul,
                      {:num, 2}, {:var, :x}
                      }
                }
            }
    d1 = derive(e1, :x)
    io_write_expr(e1, d1)

    test= {:div, {:num, 1}, {:mul,
      {:num, 2}, {:sin,
         {:add, {:var, :x}, {:num, 1}}}}}
    res = derive(test, :x)
    io_write_expr(test, res)
    :ok
  end


  def test_ass_mul() do
    e = {:mul, {:num,3}, {:mul, {:num, 2}, {:var, :x}}}

    IO.write("BEFORE: #{pprint(e)}\n")
    IO.write("AFTER: #{pprint(simplify(e))}\n")

    e2 = {:mul, {:num, 3}, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 2}}}}
    IO.write("BEFORE: #{pprint(e2)}\n")
    IO.write("AFTER: #{pprint(simplify(e2))}\n")

    e3 = {:mul, {:num, 3}, {:mul, {:exp, {:var, :x}, {:num, 2}}, {:num, 2}}}
    IO.write("BEFORE: #{pprint(e3)}\n")
    IO.write("AFTER: #{pprint(simplify(e3))}\n")

    e3 = {:mul, {:num, 3}, {:mul, {:num, 2}, {:div, {:num, 1}, {:var, :x}}}}
    IO.write("BEFORE: #{pprint(e3)}\n")
    IO.write("AFTER: #{pprint(simplify(e3))}\n")
    e3 = {:mul, {:num, 3}, {:mul, {:div, {:num, 1}, {:var, :x}}, {:num, 2}}}
    IO.write("BEFORE: #{pprint(e3)}\n")
    IO.write("AFTER: #{pprint(simplify(e3))}\n")

    e3 = {:mul, {:num, 3}, {:mul, {:num, -2}, {:sin,{:var, :x}}}}
    IO.write("BEFORE: #{pprint(e3)}\n")
    IO.write("AFTER: #{pprint(simplify(e3))}\n")
    e3 = {:mul, {:num, 3}, {:mul, {:sin, {:var, :x}}, {:num, -2}}}
    IO.write("BEFORE: #{pprint(e3)}\n")
    IO.write("AFTER: #{pprint(simplify(e3))}\n")

    e3 = {:mul, {:mul, {:num, 2}, {:sin, {:var, :x}}}, {:mul, {:num, -1}, {:exp, {:var, :x}, {:num, 2}}} }
    IO.write("BEFORE: #{pprint(e3)}\n")
    IO.write("AFTER: #{pprint(simplify(e3))}\n")


  end



end
