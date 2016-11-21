defmodule Caster.DownloadController do
  use Caster.Web, :controller
  alias Caster.Cast

  def create(conn, %{"cast_id" => cast_id}) do
    cast = Repo.get!(Cast, cast_id)
    downloader =
      cond do
        conn.assigns[:downloader] -> conn.assigns[:downloader]
        cast.source == "customcast" -> Caster.CustomCastDownloader.ProdClient
        cast.source == "vimcast" -> Caster.VimCast.Downloader
        :otherwise -> raise "something is broken"
      end
      #downloader.download!(cast)

    send_resp(conn, :ok, "")
  end

  def delete(conn, %{"cast_id" => cast_id}) do
    cast = Repo.get!(Cast, cast_id)
    File.rm!(cast.file_location)
    changeset = Cast.changeset(cast, %{file_location: nil})
    Repo.update!(changeset)
    send_resp(conn, :ok, "")
  end

end
