defmodule Caster.DownloadControllerTest do
  use Caster.ConnCase
  alias Caster.CustomCast

  test "can download a custom cast", %{conn: conn} do
    custom_cast = Repo.insert!(%CustomCast{title: "customcasttest", url: "a" })
    conn = conn
           |> assign(:downloader, Caster.CustomCastDownloader.TestClient)
    conn = post conn, cast_download_path(conn, :create, custom_cast)
    assert html_response(conn, 302)
    custom_cast = Repo.get!(CustomCast, custom_cast.id)
    assert custom_cast.file_location
  end
end
