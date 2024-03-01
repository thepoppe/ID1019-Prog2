defmodule Rphil do
  @timeout 100
  @dreaming 20
  @eating 20
  @delay 55
  # 3 states, dreaming | waitin | eating
  def start(hunger, strength, left, right, name, ctrl) do
    spawn_link(fn -> loop_states(:dreaming, hunger, strength, left, right, name, ctrl) end)
  end

  defp loop_states(_, 0, str, _, _, name, ctrl) do IO.puts("#{name} is done...#{str}"); send(ctrl, :done) end
  defp loop_states(_, hung, 0, _, _, name, ctrl) do IO.puts("#{name} is dead...#{hung}"); send(ctrl, :done) end

  defp loop_states(:dreaming, hunger, strength, left, right, name, ctrl) do
    #IO.puts("#{name} is sleeping @ #{System.monotonic_time(:millisecond)}")
    delay(:sleep, @dreaming)
    loop_states(:waiting, hunger, strength, left, right, name, ctrl)
  end
  defp loop_states(:waiting, hunger, strength, left, right, name, ctrl) do
    ##IO.puts("#{name} is waiting")
    #random_delay();
    ref = make_ref();
    #IO.puts("#{name} requests #{inspect(left)} @ #{System.monotonic_time(:millisecond)}")
    case Rchop.request(left, ref, @timeout) do
      :granted ->
        #IO.puts("#{name} do hold  #{inspect(left)} @ #{System.monotonic_time(:millisecond)}")
        #delay(:const, @delay)
        #IO.puts("#{name} requests #{inspect(right)} @ #{System.monotonic_time(:millisecond)}")
        case Rchop.request(right, ref, @timeout) do
          :granted ->
            #IO.puts("#{name} is holding #{inspect(right)} @ #{System.monotonic_time(:millisecond)}")
            loop_states(:eating, hunger, strength, left, right, ref, name, ctrl)
            {:timeout, ^ref} ->
            #IO.puts("#{name} throws #{inspect(left)} and #{inspect(right)} @ #{System.monotonic_time(:millisecond)}")
            return_chopsticks(left, right, ref)
            loop_states(:dreaming, hunger, strength-1, left, right, name, ctrl)
        end
      {:timeout, ^ref} ->
        #IO.puts("#{name} throws #{inspect(left)} @ #{System.monotonic_time(:millisecond)}")
        Rchop.return(left, ref)
        loop_states(:waiting, hunger, strength-1, left, right, name, ctrl)
    end
  end


  defp loop_states(:eating, hunger, strength, left, right, ref, name, ctrl) do
    #IO.puts("#{name} is eating. Hunger: #{hunger-1}. Stength: #{strength} @ #{System.monotonic_time(:millisecond)}")
    delay(:eat, @eating)
    return_chopsticks(left, right, ref)
    #IO.puts("#{name} throws #{inspect(left)} and #{inspect(right)} @ #{System.monotonic_time(:millisecond)}")
    loop_states(:dreaming, hunger-1, strength, left, right, name, ctrl)
  end

  defp return_chopsticks(left, right, ref) do
    Rchop.return(left, ref)
    Rchop.return(right, ref)
  end

  defp delay(:sleep, 0) do :ok end
  defp delay(:eat, 0) do :done end
  defp delay(:const, t) do :timer.sleep(t) end
  defp delay(_, t) do :timer.sleep(:rand.uniform(t)) end

  defp random_delay() do
    :rand.uniform(500)
  end
end
