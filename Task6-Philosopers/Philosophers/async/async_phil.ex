defmodule Aphil do
  @timeout 50
  @dreaming 1
  @eating 1
  @delay 4
  # 3 states, dreaming | waitin | eating
  def start(hunger, strength, left, right, name, ctrl) do
    spawn_link(fn -> loop_states(:dreaming, hunger, strength, left, right, name, ctrl) end)
  end

  defp loop_states(_, 0, str, _, _, name, ctrl) do IO.puts("#{name} is done...#{str}"); send(ctrl, :done) end
  defp loop_states(_, hung, 0, _, _, name, ctrl) do IO.puts("#{name} is dead...#{hung}"); send(ctrl, :done) end

  defp loop_states(:dreaming, hunger, strength, left, right, name, ctrl) do
    #IO.puts("#{name} is sleeping\n")
    delay(:sleep, @dreaming)
    loop_states(:waiting, hunger, strength, left, right, name, ctrl)
  end

  ##THIS IS NOT RIGHT
  defp loop_states(:waiting, hunger, strength, left, right, name, ctrl) do
    #IO.puts("#{name} is waking up\n")
    IO.puts("#{name} requests #{inspect(left)} @ #{System.monotonic_time(:millisecond)}")
    Achop.request(left, self())
    receive do
      :granted ->
        IO.puts("#{name} do hold  #{inspect(left)} @ #{System.monotonic_time(:millisecond)}")
        IO.puts("#{name} requests #{inspect(right)} @ #{System.monotonic_time(:millisecond)}")
        Achop.request(right, self())
      #delay(:const, @delay)
      receive do
        :granted ->
          IO.puts("#{name} do hold  #{inspect(left)} @ #{System.monotonic_time(:millisecond)}")
          loop_states(:eating, hunger, strength, left, right, name, ctrl)
      after @timeout -> return_chopsticks(left, right)
        IO.puts("#{name} throws #{inspect(left)} and #{inspect(right)} @ #{System.monotonic_time(:millisecond)}")
        loop_states(:dreaming, hunger, strength-1, left, right, name, ctrl)
      end
    end
  end


  defp loop_states(:eating, hunger, strength, left, right, name, ctrl) do
    IO.puts("#{name} is eating. hungerstatus: #{hunger-1}\n")
    IO.puts("#{name} throws #{inspect(left)} and #{inspect(right)} @ #{System.monotonic_time(:millisecond)}")
    delay(:eat, @eating)
    return_chopsticks(left, right)
    loop_states(:dreaming, hunger-1, strength, left, right, name, ctrl)
  end

  defp return_chopsticks(left, right) do
    Achop.return(left)
    Achop.return(right)
  end

  defp delay(:sleep, 0) do :ok end
  defp delay(:eat, 0) do :done end
  defp delay(:const, t) do :timer.sleep(t) end
  defp delay(_, t) do :timer.sleep(:rand.uniform(t)) end

end
