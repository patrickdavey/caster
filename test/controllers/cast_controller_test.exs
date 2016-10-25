defmodule Caster.PageControllerTest do
  use Caster.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200)
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cast_path(conn, :show, -1)
    end
  end

end
