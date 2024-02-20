defmodule Philosopher do
  # 3 states, dreaming | waitin | eating
  def start(hunger, left, right, name, ctrl) do
    spawn_link(fn -> loop(:dreaming, hunger, left, right, name, ctrl) end)
  end

  def loop(_, 0, _, _, _, ctrl) do send(ctrl, :done) end
  def loop(:dreaming, hunger, left, right, name, ctrl) do
    IO.puts("#{name} is sleeping\n")
    sleep(1000)
    loop(:waiting, hunger, left, right, name, ctrl)
  end

  def loop(:waiting, hunger, left, right, name, ctrl) do
    case waiting(left, right ,name) do
      :move_on -> loop(:eating, hunger, left, right, name, ctrl)
    end
  end

  def loop(:eating, hunger, left, right, name, ctrl) do
    IO.puts("#{name} is eating. hungerstatus: #{hunger-1}\n")
    eat(1000)
    Chopstick.return(left)
    Chopstick.return(right)
    loop(:dreaming, hunger-1, left, right, name, ctrl)
  end




  def sleep(0) do :ok end
  def sleep(t) do :timer.sleep(:rand.uniform(t)) end

  def eat(0) do :done end
  def eat(t) do :timer.sleep(:rand.uniform(t)) end

  def waiting(left, right, name) do
    case Chopstick.request(left) do
      #{_, :timeout} -> waiting(left, right, name)
      {_, :taken} ->
        IO.puts("#{name} took left chop stick\n")
        #delay(500)
        get_right_stick(right, name)
    end
  end
  def get_right_stick(right, name) do
    case Chopstick.request(right) do
      #{_, :timeout} -> get_right_stick(right, name)
      {_, :taken} -> IO.puts("#{name} took right chop stick\n"); :move_on
    end
  end


  def delay(t) do :timer.sleep(t) end


end
