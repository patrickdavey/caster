defmodule Caster.PageControllerTest do
  use Caster.ConnCase
  alias Caster.VimCast
  alias Caster.Cast

  test "updates post correctly", %{conn: conn} do
    note_attr = %{note: "some new note"}
    cast = Repo.insert!(%VimCast{title: "vimcasttest", url: "a"})
    put conn, cast_path(conn, :update, cast, cast: note_attr)
    cast = Repo.get!(Cast, cast.id)
    assert cast.note == "some new note"
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
    assert conn.status == 200
    cast = Repo.get!(Cast, cast.id)
    assert cast.viewed
  end
end
