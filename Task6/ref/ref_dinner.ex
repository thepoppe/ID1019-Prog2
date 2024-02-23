defmodule Rdinner do
  def start(n), do: spawn(fn -> init(n) end)
  def init(n) do
    c1 = Rchop.start()
    c2 = Rchop.start()
    c3 = Rchop.start()
    c4 = Rchop.start()
    c5 = Rchop.start()
    ctrl = self()
    t0 = :erlang.timestamp()
    Rphil.start(n, n, c1, c2, :A, ctrl)
    Rphil.start(n, n, c2, c3, :B, ctrl)
    Rphil.start(n, n, c3, c4, :C, ctrl)
    Rphil.start(n, n, c4, c5, :D, ctrl)
    Rphil.start(n, n, c5, c1, :E, ctrl)
    wait(5, [c1, c2], t0)
  end

  def wait(0, chopsticks, t0) do
    t1 = :erlang.timestamp()
    IO.puts("All philosophers are done eating in #{div(:timer.now_diff(t1,t0), 1000)} ms")
    Enum.each(chopsticks, fn(c) -> Rchop.quit(c) end)
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
