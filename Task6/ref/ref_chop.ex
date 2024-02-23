defmodule Rchop do

  def start do
    spawn_link(fn -> available() end)
    end

  defp available do
    receive do
    {:request, ref, caller_pid} ->
      send(caller_pid, {:granted, ref});
      gone(ref);
    :quit -> :ok
    end
  end

  defp gone(ref) do
    receive do
      {:return, ^ref} -> available();
      {:return, _} -> gone(ref);
      :quit -> :ok
    end
  end

  def request(stick, ref, timeout) do
    send(stick, {:request, ref, self()})
    wait(ref, timeout)
  end

  def wait(ref, timeout) do
    receive do
      {:granted, ^ref} -> :granted
      {:granted, _} ->  wait(ref, timeout)
      :quit -> :ok
      after timeout -> {:timeout, ref}
    end
  end

  def return(stick, ref) do
    send(stick, {:return, ref})
  end

  def quit(stick) do
    Process.exit(stick, :kill)
    {stick, :killed}
  end

end
