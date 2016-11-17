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

  describe "state is returned correctly for casts" do
    test "viewed cast" do
      test_cast = %Caster.Cast{id: 1, viewed: true}

      cast_representation = Phoenix.View.render(Caster.CastView, "cast.json", %{cast: test_cast})
      assert cast_representation == %{
        id: test_cast.id,
        title: nil,
        interesting: test_cast.interesting,
        source: nil,
        note: nil,
        state: "viewed"
      }
    end

    test "downloaded cast" do
      test_cast = %Caster.Cast{id: 1, file_location: "something"}

      cast_representation = Phoenix.View.render(Caster.CastView, "cast.json", %{cast: test_cast})
      assert cast_representation == %{
        id: test_cast.id,
        title: nil,
        interesting: test_cast.interesting,
        source: nil,
        note: nil,
        state: "downloaded"
      }
    end

    test "fresh cast" do
      test_cast = %Caster.Cast{id: 1, file_location: nil, viewed: false }

      cast_representation = Phoenix.View.render(Caster.CastView, "cast.json", %{cast: test_cast})
      assert cast_representation == %{
        id: test_cast.id,
        title: nil,
        interesting: test_cast.interesting,
        source: nil,
        note: nil,
        state: "fresh"
      }
    end
  end
end
