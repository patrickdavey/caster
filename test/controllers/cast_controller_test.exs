defmodule Caster.PageControllerTest do
  use Caster.ConnCase
  alias Caster.CustomCast
  alias Caster.VimCast

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
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cast_path(conn, :show, -1)
    end
  end

end
