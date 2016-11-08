defmodule Caster.PageControllerTest do
  use Caster.ConnCase
  alias Caster.CustomCast
  alias Caster.VimCast
  alias Caster.Cast

  test "GET /", %{conn: conn} do
    Repo.insert!(%VimCast{title: "vimcasttest", url: "a"})
    Repo.insert!(%CustomCast{title: "customcasttest", url: "a" })
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "customcasttest"
    refute html_response(conn, 200) =~ "vimcasttest"
  end

  test "GET /?type=vimcast", %{conn: conn} do
    Repo.insert!(%VimCast{title: "vimcasttest", url: "a"})
    Repo.insert!(%CustomCast{title: "customcasttest", url: "a" })
    conn = get conn, "/?type=vimcast"
    refute html_response(conn, 200) =~ "customcasttest"
    assert html_response(conn, 200) =~ "vimcasttest"
    assert html_response(conn, 200) =~ "Listing Vimcasts"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cast_path(conn, :show, -1)
    end
  end

  test "can watch a custom cast", %{conn: conn} do
    cast = Repo.insert!(%Cast{title: "some cast", source: "something", file_location: "some_location" })
    refute cast.viewed
    conn = conn
           |> assign(:viewer, Caster.CastViewer.TestClient)
    conn = get conn, cast_path(conn, :show, cast.id)
    assert html_response(conn, 302)
    cast = Repo.get!(Cast, cast.id)
    assert cast.viewed
  end
end
