defmodule Chopstick do

  def start do
    spawn_link(fn -> available() end)
    end

  defp available do
    receive do
    {:request, caller_pid} ->
      send(caller_pid, :granted);
      gone();
    :quit -> :ok
    end
  end

  defp gone() do
    receive do
      :return -> available();
      :quit -> :ok
    end
  end

  def request(stick, timeout) do
    send(stick, {:request, self()})
    receive do
      :granted ->  {stick, :taken}
      :quit -> :ok
      after timeout -> {stick, :timeout}
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
