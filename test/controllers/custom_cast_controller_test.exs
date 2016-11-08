defmodule Caster.CustomCastControllerTest do
  use Caster.ConnCase

  alias Caster.CustomCast
  @valid_attrs %{url: "https://www.youtube.com/watch?v=muFHHa370Ks"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, cast_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Custom"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, custom_cast_path(conn, :new)
    assert html_response(conn, 200) =~ "New custom cast"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, custom_cast_path(conn, :create), custom_cast: @valid_attrs
    assert redirected_to(conn) == cast_path(conn, :index)
    assert Repo.get_by(CustomCast, @valid_attrs)
  end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, custom_cast_path(conn, :create), custom_cast: @invalid_attrs
  #   assert html_response(conn, 200) =~ "New custom cast"
  # end

  # test "shows chosen resource", %{conn: conn} do
  #   custom_cast = Repo.insert! %CustomCast{}
  #   conn = get conn, custom_cast_path(conn, :show, custom_cast)
  #   assert html_response(conn, 200) =~ "Show custom cast"
  # end

end
