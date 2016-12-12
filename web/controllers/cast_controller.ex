defmodule Caster.CastController do
  use Caster.Web, :controller
  alias Caster.Cast

  plug :set_source when action in [:index]

  def index(conn, _params) do
    s = Atom.to_string(conn.assigns.source.source)
    order = Map.get(conn.assigns.source, :order, [desc: :inserted_at])
    casts = Caster.Cast
            |> where([source: ^s])
            |> order_by(^order)
            |> Caster.Repo.all

    render conn, :index, casts: casts, source: s
  end

  def show(conn, %{"id" => id}) do
    cast = Repo.get!(Cast, id)

    viewer =
      cond do
        conn.assigns[:viewer] -> conn.assigns[:viewer]
        :otherwise -> Caster.CastViewer.ProdClient
      end

    viewer.view!(cast)

    send_resp(conn, :ok, "")
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

  defp set_source(%Plug.Conn{params: %{"source" => source}} = conn, _) do
    assign(conn, :source, Caster.SourceFinder.find(source))
  end

  defp set_source(conn, _) do
    assign(conn, :source, Caster.SourceFinder.find(:customcast))
  end
end
