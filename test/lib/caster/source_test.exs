defmodule Caster.SourceTest do
  use Caster.ModelCase

  test "can find a source by string" do
    source = Caster.Source.find("vimcast")
    assert source.title == "Vimcasts"
  end

  test "can find a source by atom" do
    source = Caster.Source.find(:vimcast)
    assert source.title == "Vimcasts"
  end
end
