defmodule Caster.CastController do
  use Caster.Web, :controller
  alias Caster.Cast

  def index(conn, %{"type" => "vimcast"}) do
    casts =
      Repo.all(Caster.VimCast.sorted)

    render conn, :index, casts: casts, title: "Vimcasts"
  end

  def index(conn, _params) do
    casts = Repo.all(from c in Caster.CustomCast,
      where: c.source == "customcast",
      select: c)
    render conn, :index, casts: casts, title: "Custom Casts"
  end

  def show(conn, %{"id" => id}) do
    cast = Repo.get!(Cast, id)

    viewer =
      cond do
        conn.assigns[:viewer] -> conn.assigns[:viewer]
        :otherwise -> Caster.CastViewer.ProdClient
      end

    viewer.view!(cast)

    conn
    |> put_flash(:info, "Lauching Cast in VLC...")
    |> redirect(to: cast_path(conn, :index))
  end

  def update(conn, %{"id" => id, "cast" => cast_params}) do
    cast = Repo.get!(Cast, id)
    changeset = Cast.changeset(cast, cast_params)
    case Repo.update(changeset) do
      {:ok, _} ->
        send_resp(conn, :ok, "")
      {:error, _} ->
        send_resp(conn, :bad_request, "")
    end
  end

end
