defmodule Adinner do
  def start(n), do: spawn(fn -> init(n) end)
  def init(n) do
    c1 = Achop.start()
    c2 = Achop.start()
    c3 = Achop.start()
    c4 = Achop.start()
    c5 = Achop.start()
    ctrl = self()
    t0 = :erlang.timestamp()
    Aphil.start(n, c1, c2, :arendt, ctrl)
    Aphil.start(n, c2, c3, :hypatia, ctrl)
    Aphil.start(n, c3, c4, :simone, ctrl)
    Aphil.start(n, c4, c5, :elisabeth, ctrl)
    Aphil.start(n, c1, c5, :ayn, ctrl)
    wait(5, [c1, c2, c3, c4, c5], t0)
  end

  def wait(0, chopsticks, t0) do
    t1 = :erlang.timestamp()
    IO.puts("All philosophers are done eating in #{div(:timer.now_diff(t1,t0), 1000)} ms")
    Enum.each(chopsticks, fn(c) -> Achop.quit(c) end)
    end
  def wait(n, chopsticks, t0) do
    receive do
    :done ->
      wait(n - 1, chopsticks, t0)
    :abort ->
      Process.exit(self(), :kill)
    end
  end


  end
