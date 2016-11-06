defmodule Caster.CastView do
  use Caster.Web, :view

  def cast_link(conn, cast = %{ file_location: nil }) do
    button "Download", to: cast_download_path(conn, :create, cast), class: "btn btn-default btn-xs"
  end

  def cast_link(conn, cast) do
    link "Show", to: cast_path(conn, :show, cast), class: "btn btn-default btn-xs"
  end

end
