defmodule Caster.CastController do
  use Caster.Web, :controller
  alias Caster.Cast

  plug :set_source when action in [:index]

  def index(conn, params) do
    casts = Caster.Cast
            |> where([c], c.source == ^conn.assigns.source)
            |> order_by([c], [desc: c.episode])
            |> Caster.Repo.all

    render conn, :index, casts: casts, source: conn.assigns.source
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
    assign(conn, :source, source)
  end

  defp set_source(conn, _) do
    assign(conn, :source, "customcast")
  end
end
