defmodule Philref do
  @timeout 50
  @dreaming 4000
  @eating 2000
  @delay 0
  # 3 states, dreaming | waitin | eating
  def start(hunger, strength, left, right, name, ctrl) do
    spawn_link(fn -> loop_states(:dreaming, hunger, strength, left, right, name, ctrl) end)
  end

  defp loop_states(_, 0, strength, _, _, name, ctrl) do IO.puts("#{name} is happy, with strength: #{strength}\n"); send(ctrl, :done) end
  defp loop_states(_, hunger, 0, _, _, name, ctrl) do IO.puts("#{name} died with hunger: #{hunger}\n"); send(ctrl, :done) end
  defp loop_states(:dreaming, hunger, strength, left, right, name, ctrl) do
    IO.puts("#{name} is sleeping\n")
    delay(:sleep, @dreaming)
    loop_states(:waiting, hunger, strength, left, right, name, ctrl)
  end


  defp loop_states(:waiting, hunger, strength, left, right, name, ctrl) do
    ref = make_ref()
    IO.puts("#{name} is waiting\n")

    case Chopref.request(left, ref, @timeout) do
      :timeout ->
        Chopref.return(left, ref)
        loop_states(:waiting, hunger, strength - 1, left, right, name, ctrl)
      :taken ->
        #IO.puts("#{name} took left chop stick\n")
        #IO.puts("#{name} wants right chop stick\n")
        delay(:const, @delay)
        case Chopref.request(right, ref, @timeout) do
          :timeout ->
            return_chopsticks(left, right , ref)
            loop_states(:waiting, hunger, strength - 1, left, right, name, ctrl)
          :taken ->
            #IO.puts("#{name} took right chop stick\n");
            loop_states(:eating, hunger, strength, ref, left, right, name, ctrl)
        end
    end
  end


  defp loop_states(:eating, hunger, strength, ref, left, right, name, ctrl) do
    IO.puts("#{name} is eating. hungerstatus: #{hunger-1}\n")
    delay(:eat, @eating)
    return_chopsticks(left, right, ref)
    loop_states(:dreaming, hunger-1, strength, left, right, name, ctrl)
  end

  defp return_chopsticks(left, right, ref) do
    Chopref.return(left, ref)
    Chopref.return(right, ref)
  end

  defp delay(:sleep, 0) do :ok end
  defp delay(:eat, 0) do :done end
  defp delay(:const, t) do :timer.sleep(t) end
  defp delay(_, t) do :timer.sleep(:rand.uniform(t)) end

end
