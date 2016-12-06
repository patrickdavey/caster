defmodule Caster.Source do
  def all do
    Application.get_env(:caster, Caster.Sources)
    |> Enum.flat_map(fn({_key, sources}) -> sources end)
  end

  def find(source) when is_bitstring(source) do
    all
    |> Enum.find(fn(s) -> s.source == String.to_atom(source) end)
  end

  def find(source) when is_atom(source) do
    all
    |> Enum.find(fn(s) -> s.source == source end)
  end
end
