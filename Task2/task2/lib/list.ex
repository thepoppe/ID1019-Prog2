defmodule EnvList do

  def new() do [] end

  def add(map, key, value) do
    element = {key, value}
    add(map, element)
  end
  def add([], e) do [e|[]] end
  def add([h|t], e) do
    {h_key, _} = h
    {new_key, _} = e
    if h_key == new_key do [e|t]
    else [h|add(t, e)]
    end
  end

  def lookup([], _) do nil end
  def lookup([h|t], key) do
    {h_key, _} = h
    if h_key == key do h
    else lookup(t, key)
    end
  end

  def remove([], _) do [] end
  def remove([{key, _}|rest], key) do rest end
  def remove([h|rest], key) do [h|remove(rest, key)] end



end
