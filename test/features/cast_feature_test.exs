defmodule Caster.Features.CastTest do
  use Caster.ModelCase
  alias Caster.VimCast
  use Hound.Helpers

  @moduletag :feature

  hound_session

  test "lists all entries on index for vimcast" do
    Repo.insert!(%VimCast{title: "happy", url: "a"})
    navigate_to("/casts?type=vimcast")
    element_text = find_element(:css, "h1") |> visible_text
    assert Regex.match?(~r/Vimcasts/, element_text)
    assert Regex.match?(~r/happy/, visible_page_text())
  end

  test "lists all entries on index for custom" do
    Repo.insert!(%Caster.CustomCast{title: "happycustom", url: "a"})
    navigate_to("/casts")
    element_text = find_element(:css, "h1") |> visible_text
    assert Regex.match?(~r/Custom Casts/, element_text)
    assert Regex.match?(~r/happycustom/, visible_page_text())
  end

  test "the new page can be displayed correctly" do
    navigate_to("/custom_casts/new")
    element_text = find_element(:css, ".container h2") |> visible_text
    assert Regex.match?(~r/New custom cast/i, element_text)
  end

end
