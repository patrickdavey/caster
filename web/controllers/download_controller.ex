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

    downloader.download!(cast)

    conn
    |> put_flash(:info, "Cast downloading...")
    |> redirect(to: cast_path(conn, :index))
  end

  def destroy(conn, _) do
    conn
    |> put_flash(:info, "Cast deleted.")
    |> redirect(to: cast_path(conn, :index))
  end

end
