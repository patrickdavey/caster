defmodule Caster.RefreshControllerTest do
  use Caster.ConnCase

  test "can refresh vimcasts", %{conn: conn} do
    conn = put conn, refresh_path(conn, :update, "vimcast")
    assert conn.status == 200
  end
end
