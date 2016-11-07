defmodule Caster.CastController do
  use Caster.Web, :controller
  alias Caster.Cast

  def index(conn, %{"type" => source}) do
    casts = Repo.all(from c in Caster.CustomCast,
      where: c.source == ^source,
      select: c)
    render(conn, "index.html", casts: casts)
  end

  def index(conn, _params) do
    casts = Repo.all(from c in Caster.CustomCast,
      where: c.source == "customcast",
      select: c)
    render(conn, "index.html", casts: casts)
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

end
