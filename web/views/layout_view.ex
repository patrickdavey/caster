defmodule Caster.LayoutView do
  use Caster.Web, :view

  def sources do
    Caster.Source.all
  end

  def title_for_source(source) do
    Caster.Source.find(source)
    |> Map.fetch!(:title)
  end
end
