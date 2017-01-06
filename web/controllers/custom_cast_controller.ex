defmodule Caster.CustomCastController do
  use Caster.Web, :controller

  alias Caster.CustomCast
  alias Caster.CustomCastDownloader

  def new(conn, _params) do
    changeset = CustomCast.changeset(%CustomCast{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"custom_cast" => %{"url" => url}}) do
    downloader = conn.assigns[:downloader] || CustomCastDownloader.ProdClient

    case downloader.get_info(%{url: url}) do
      %{"_type" => "playlist", "entries" => entries} ->
        entries
        |> Enum.each(&insert_custom(&1))
      %{"title" => title} ->
        insert_custom(title, url)
    end

    conn
    |> put_flash(:info, "Custom cast created successfully.")
    |> redirect(to: cast_path(conn, :index))
  end

  defp insert_custom(%{"title" => title, "url" => url}) do
    %CustomCast{title: title, url: url}
    |> CustomCast.changeset
    |> Repo.insert
  end

  defp insert_custom(title, url) do
    %CustomCast{title: title, url: url}
    |> CustomCast.changeset
    |> Repo.insert
  end

end
