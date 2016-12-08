defmodule Caster.RefreshController do
  use Caster.Web, :controller
  plug :set_source when action in [:update]

  def update(conn, %{"id" => id}) do
    cond do
      conn.assigns.source.source == :vimcast ->
        casts = Caster.Feed.VimCastFeed.fetch!
        render(conn, Caster.CastView, :index, casts: casts, source: Atom.to_string(conn.assigns.source.source))

      :otherwise -> nil
    end
  end

  defp set_source(%Plug.Conn{params: %{"id" => source}} = conn, _) do
    assign(conn, :source, Caster.Source.find(source))
  end
end
