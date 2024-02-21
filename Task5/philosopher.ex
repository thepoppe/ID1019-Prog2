defmodule Philosopher do
  # 3 states, dreaming | waitin | eating
  def start(hunger, left, right, name, ctrl) do
    spawn_link(fn -> loop_states(:dreaming, hunger, left, right, name, ctrl) end)
  end

  defp loop_states(_, 0, _, _, _, ctrl) do send(ctrl, :done) end

  defp loop_states(:dreaming, hunger, left, right, name, ctrl) do
    IO.puts("#{name} is sleeping\n")
    delay(:sleep, 100)
    loop_states(:waiting, hunger, left, right, name, ctrl)
  end
  defp loop_states(:waiting, hunger, left, right, name, ctrl) do
    case request_chopsticks(left, right ,name) do
      :move_on -> loop_states(:eating, hunger, left, right, name, ctrl)
    end
  end
  defp loop_states(:eating, hunger, left, right, name, ctrl) do
    IO.puts("#{name} is eating. hungerstatus: #{hunger-1}\n")
    delay(:eat, 1000)
    return_chopsticks(left,right)
    loop_states(:dreaming, hunger-1, left, right, name, ctrl)
  end

  defp request_chopsticks(left, right, name) do
    case Chopstick.request(left, 500) do
      {_, :taken} ->
        IO.puts("#{name} took left chop stick\n")
        delay(:const, 300)
        case Chopstick.request(right, 500) do
          {_, :timeout} ->
            return_chopsticks(left, right)
            request_chopsticks(left, right, name)
            {_, :taken} ->
              IO.puts("#{name} took right chop stick\n");
              :move_on
        end
    end
  end

  defp return_chopsticks(left, right) do
    Chopstick.return(left)
    Chopstick.return(right)
  end

  defp delay(:sleep, 0) do :ok end
  defp delay(:eat, 0) do :done end
  defp delay(:const, t) do :timer.sleep(t) end
  defp delay(_, t) do :timer.sleep(:rand.uniform(t)) end

end
