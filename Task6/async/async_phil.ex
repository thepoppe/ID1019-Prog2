defmodule Aphil do
  @timeout 50
  @dreaming 1
  @eating 1
  @delay 4
  # 3 states, dreaming | waitin | eating
  def start(hunger, left, right, name, ctrl) do
    spawn_link(fn -> loop_states(:dreaming, hunger, left, right, name, ctrl) end)
  end

  defp loop_states(_, 0, _, _, name, ctrl) do IO.puts("#{name} is done"); send(ctrl, :done) end

  defp loop_states(:dreaming, hunger, left, right, name, ctrl) do
    #IO.puts("#{name} is sleeping\n")
    delay(:sleep, @dreaming)
    loop_states(:waiting, hunger, left, right, name, ctrl)
  end
  defp loop_states(:waiting, hunger, left, right, name, ctrl) do
    #IO.puts("#{name} is waking up\n")
    Achop.request(left, self())
    receive do
      :granted -> Achop.request(right, self())
      delay(:const, @delay)
      receive do
        :granted -> loop_states(:eating, hunger, left, right, name, ctrl)
      end
    end
  end


  defp loop_states(:eating, hunger,  left, right, name, ctrl) do
    #IO.puts("#{name} is eating. hungerstatus: #{hunger-1}\n")
    delay(:eat, @eating)
    return_chopsticks(left, right)
    loop_states(:dreaming, hunger-1, left, right, name, ctrl)
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
