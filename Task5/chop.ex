defmodule Stick do

  def start do
    #IO.inspect("START")
    stick = spawn_link(fn -> available() end)
    end

  def available do
    #IO.inspect("AVAILABLE")
    receive do
    {:request, from} -> send(from, :granted); gone()
    :quit -> :ok
    end
  end

  def gone() do
    #IO.inspect("GONE")
    receive do
    :return -> available()
    :quit -> :ok
    end
  end
  def request(stick) do
    #IO.inspect("REQUEST")
    send(stick, {:request, self()})
    receive do
      :granted ->  {stick, :taken}
      :quit -> :ok
    end
  end

  def return(stick) do
    send(stick, :return)
    {stick, :available}
  end

  def terminate(stick) do
    Process.exit(stick, :kill)
    {stick, :killed}
  end

end
