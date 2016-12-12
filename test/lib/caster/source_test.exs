defmodule Caster.SourceTest do
  use Caster.ModelCase
  alias Caster.SourceFinder
  alias Caster.Source

  test "can find a source by string" do
    %Source{title: title} = SourceFinder.find("vimcast")
    assert title == "Vimcasts"
  end

  test "can find a source by atom" do
    %Source{title: title} = SourceFinder.find(:vimcast)
    assert title == "Vimcasts"
  end
end
