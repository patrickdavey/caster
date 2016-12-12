defmodule Caster.SourceFinder do
  alias Caster.Source
  def all do
    Application.get_env(:caster, Caster.Sources)
    |> Enum.flat_map(fn({_key, sources}) -> sources end)
    |> Enum.map(&to_source/1)
  end

  def find(source) when is_bitstring(source) do
    all
    |> Enum.find(fn(%Source{source: s}) -> s == String.to_atom(source) end)
  end

  def find(source) when is_atom(source) do
    all
    |> Enum.find(fn(%Source{source: s}) -> source == s end)
  end

  defp to_source(struct) do
    struct(Source, struct)
  end
end
