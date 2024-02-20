defmodule Chopstick do

  def start do
    #IO.inspect("START")
    stick = spawn_link(fn -> available() end)
    end

  def available do
    #IO.inspect("AVAILABLE")
    #IO.inspect(self())
    receive do
    {:request, caller_pid} ->
      send(caller_pid, :granted);
      gone();
    #:return -> available();
    :quit -> :ok
    end
  end

  def gone() do
    #IO.inspect("GONE")
    #IO.inspect(self())
    receive do
      :return -> available();
      :quit -> :ok
    end
  end

  def request(stick) do
    #IO.inspect("REQUEST")
    send(stick, {:request, self()})
    receive do
      :granted ->  {stick, :taken}
      :quit -> :ok
      #after timeout -> {stick, :timeout}
    end
  end

  def return(stick) do
    send(stick, :return)
  end

  def quit(stick) do
    Process.exit(stick, :kill)
    {stick, :killed}
  end

end
