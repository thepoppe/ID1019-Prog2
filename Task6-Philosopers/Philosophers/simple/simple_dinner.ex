defmodule Sdinner do
  def start(n), do: spawn(fn -> init(n) end)
  def init(n) do
    c1 = Schop.start()
    c2 = Schop.start()
    c3 = Schop.start()
    c4 = Schop.start()
    c5 = Schop.start()
    ctrl = self()
    t0 = :erlang.timestamp()
    Sphil.start(n, c1, c2, :arendt, ctrl)
    Sphil.start(n, c2, c3, :hypatia, ctrl)
    Sphil.start(n, c3, c4, :simone, ctrl)
    Sphil.start(n, c4, c5, :elisabeth, ctrl)
    Sphil.start(n, c1, c5, :ayn, ctrl)
    wait(5, [c1, c2, c3, c4, c5], t0)
  end

  def wait(0, chopsticks, t0) do
    t1 = :erlang.timestamp()
    IO.puts("All philosophers are done eating in #{div(:timer.now_diff(t1,t0), 1000)} ms")
    Enum.each(chopsticks, fn(c) -> Schop.quit(c) end)
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
