defmodule Caster.LayoutView do
  use Caster.Web, :view

  def sources do
    Application.get_env(:caster, Caster.Sources)
    |> Enum.flat_map(fn({key, sources}) -> sources end)
  end

  def title_for_source(source) do
    sources
    |> Enum.find(fn(s) -> s.source == String.to_atom(source) end)
    |> Map.fetch!(:title)
  end
end
