defmodule Caster.LayoutView do
  use Caster.Web, :view
  alias Caster.Source

  def sources do
    Caster.SourceFinder.all
  end

  def title_for_source(source = %Source{}) do
    source.title
  end
end
