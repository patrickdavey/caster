defmodule Caster.LayoutView do
  use Caster.Web, :view

  def sources do
    Caster.SourceFinder.all
  end

  def title_for_source(source) do
    Caster.SourceFinder.find(source)
    |> Map.fetch!(:title)
  end
end
