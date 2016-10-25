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
    render(conn, "show.html", cast: cast)
  end

end
