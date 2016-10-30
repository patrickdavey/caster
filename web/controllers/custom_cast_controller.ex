defmodule Caster.CustomCastController do
  use Caster.Web, :controller

  alias Caster.CustomCast
  alias Caster.CustomCastDownloader

  def new(conn, _params) do
    changeset = CustomCast.changeset(%CustomCast{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"custom_cast" => %{"url" => url}}) do
    {:ok, title} = CustomCastDownloader.get_title(%CustomCast{url: url})
    changeset = CustomCast.changeset(%CustomCast{}, %{title: title, url: url})

    case Repo.insert(changeset) do
      {:ok, _custom_cast} ->
        conn
        |> put_flash(:info, "Custom cast created successfully.")
        |> redirect(to: cast_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end
