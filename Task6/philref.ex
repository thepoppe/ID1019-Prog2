defmodule Philref do
  @timeout 5
  @dreaming 1
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
      {:move_on, ref} -> loop_states(:eating, hunger, ref, left, right, name, ctrl)
    end
  end


  defp loop_states(:eating, hunger, ref, left, right, name, ctrl) do
    IO.puts("#{name} is eating. hungerstatus: #{hunger-1}\n")
    delay(:eat, @eating)
    return_chopsticks(left, right, ref)
    loop_states(:dreaming, hunger-1, left, right, name, ctrl)
  end

  defp request_chopsticks(left, right, name) do
    ref = make_ref()
    case Chopstick.request(left, ref, @timeout) do
      {_, :timeout} ->
        return_chopsticks(left, :null, ref)
        request_chopsticks(left, right, name)
      {_, :taken, ref} ->
        IO.puts("#{name} took left chop stick\n")
        delay(:const, @delay)
        case Chopstick.request(right, ref, @timeout) do
          {_, :timeout} ->
            return_chopsticks(left, right , ref)
            request_chopsticks(left, right, name)
            {_, :taken, ref} ->
            IO.puts("#{name} took right chop stick\n");
            {:move_on, ref}
        end
    end
  end

  defp return_chopsticks(left, right, ref) do
    case {left, right} do
      {left, :null} -> Chopstick.return(left, ref)
      {:null, right} -> Chopstick.return(right, ref)
      {left, right} ->
        Chopstick.return(left, ref)
        Chopstick.return(right, ref)
      end
  end

  defp delay(:sleep, 0) do :ok end
  defp delay(:eat, 0) do :done end
  defp delay(:const, t) do :timer.sleep(t) end
  defp delay(_, t) do :timer.sleep(:rand.uniform(t)) end





  defp loop_states(:lesson, hunger, left, right, name, ctrl) do
    ref = make_ref()
    case Chopstick.request(left, ref, @timeout) do
      {_, :taken} ->
        delay(:const, @delay)
        case Chopstick.request(right, ref, @timeout) do
        {_, :taken} -> loop_states(:eating, hunger, left, right, name, ctrl)
        {_, :timeout} ->
          return_chopsticks(left, right, ref)
          loop_states(:dreaming, hunger, left, right, name, ctrl)
      end
      {_, :timeout} ->
        return_chopsticks(left, :null, ref)
        loop_states(:lesson, hunger, left, right, name, ctrl)
    end
  end
end
