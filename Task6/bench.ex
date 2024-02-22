defmodule Bench do

  def test(type) do
    range = 1..10
    range = Enum.map(range, fn x -> x * 100 end)
    time = Enum.map(range, fn x ->
      IO.inspect(x);
      t0 = System.monotonic_time(:millisecond);
      pid = type.start(x);
      loop(pid)
      t1 = System.monotonic_time(:millisecond);
      send(pid, :abort)
      File.write!("#{type}.dat", "#{x} #{t1 - t0}\n", [:append])
    end)
  end
    def loop(pid) do
      case Process.alive?(pid) do
      true -> loop(pid)
      _ -> :ok
    end
  end
end
