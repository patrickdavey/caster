defmodule Caster.RefreshController do
  use Caster.Web, :controller
  plug :set_source when action in [:update]

  def update(conn, %{"id" => _id}) do
    cond do
      conn.assigns.source.source == :vimcast ->
        casts = Caster.Feed.VimCastFeed.fetch!
        conn
        |> assign(:casts, casts)
        |> render(Caster.CastView, :index)

      :otherwise -> nil
    end
  end

  defp set_source(%Plug.Conn{params: %{"id" => source}} = conn, _) do
    assign(conn, :source, Caster.SourceFinder.find(source))
  end
end
