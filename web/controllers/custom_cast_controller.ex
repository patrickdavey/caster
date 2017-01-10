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

    resp = case downloader.get_info(%{url: url}) do
            %{"_type" => "playlist", "entries" => entries} ->
              entries
              |> Enum.each(&insert_custom(&1))
              :ok
            %{"title" => title} ->
              insert_custom(title, url)
              :ok
            _ -> :error
          end

    if resp == :ok do
      conn
      |> put_flash(:info, "Custom cast created successfully.")
      |> redirect(to: cast_path(conn, :index))
    else
      changeset = CustomCast.changeset(%CustomCast{})
      |> Ecto.Changeset.add_error(:url, "error fetching video from url")

      render(conn, "new.html", changeset: %{changeset | action: :insert})
    end
  end

  defp insert_custom(%{"title" => title, "url" => url}) do
    insert_custom(title, url)
  end

  defp insert_custom(title, url) do
    unless Repo.exists?(from c in Caster.Cast, where: c.url == ^url) do
      %CustomCast{title: title, url: url}
      |> CustomCast.changeset
      |> Repo.insert
    end
  end

end
