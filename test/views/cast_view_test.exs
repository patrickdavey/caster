defmodule Caster.PageViewTest do
  use Caster.ConnCase, async: true

  test "#cast_link is download with no file_location", %{conn: conn } do
    link = Caster.CastView.cast_link(conn, %Caster.Cast{id: 1, file_location: nil})
    link = Phoenix.HTML.safe_to_string(link)
    assert String.contains?(link, "Download")
    refute String.contains?(link, "Show")
  end

  test "#cast_link is show with file_location", %{conn: conn } do
    link = Caster.CastView.cast_link(conn, %Caster.Cast{id: 1, file_location: "location"})
    link = Phoenix.HTML.safe_to_string(link)
    refute String.contains?(link, "Download")
    assert String.contains?(link, "Show")
  end
end
