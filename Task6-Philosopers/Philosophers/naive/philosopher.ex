defmodule Philosopher do
  @timeout 50
  @dreaming 2
  @eating 1
  @delay 0
  # 3 states, dreaming | waitin | eating
  def start(hunger, left, right, name, ctrl) do
    spawn_link(fn -> loop_states(:dreaming, hunger, left, right, name, ctrl) end)
  end

  defp loop_states(_, 0, _, _, _, ctrl) do send(ctrl, :done) end

  defp loop_states(:dreaming, hunger, left, right, name, ctrl) do
    IO.puts("#{name} is sleeping\n")
    delay(:sleep, @dreaming)
    loop_states(:waiting, hunger, left, right, name, ctrl)
  end
  defp loop_states(:waiting, hunger, left, right, name, ctrl) do
    IO.puts("#{name} is waking up\n")
    case request_chopsticks(left, right, name) do
      :move_on-> loop_states(:eating, hunger, left, right, name, ctrl)
    end
  end


  defp loop_states(:eating, hunger,  left, right, name, ctrl) do
    IO.puts("#{name} is eating. hungerstatus: #{hunger-1}\n")
    delay(:eat, @eating)
    return_chopsticks(left, right)
    loop_states(:dreaming, hunger-1, left, right, name, ctrl)
  end

  defp request_chopsticks(left, right, name) do
    case Chopstick.request(left, @timeout) do
      {_, :timeout} ->
        Chopstick.return(left)
        request_chopsticks(left, right, name)
      {_, :taken} ->
        IO.puts("#{name} took left chop stick\n")
        delay(:const, @delay)
        case Chopstick.request(right, @timeout) do
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





  #defp loop_states(:lesson, hunger, left, right, name, ctrl) do
  #  case Chopstick.request(left, @timeout) do
  #    {_, :taken} -> case Chopstick.request(right, @timeout) do
  #      {_, :taken} -> loop_states(:eating, hunger, left, right, name, ctrl)
  #      {_, :timeout} ->
  #        Chopstick.return(left)
  #        Chopstick.return(right)
  #        loop_states(:dreaming, hunger, left, right, name, ctrl)
  #    end
  #    {_, :timeout} ->
  #      Chopstick.return(left)
  #      loop_states(:lesson, hunger, left, right, name, ctrl)
  #  end
  #end
end
