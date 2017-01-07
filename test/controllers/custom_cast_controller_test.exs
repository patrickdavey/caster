defmodule Caster.CustomCastControllerTest do
  use Caster.ConnCase
  alias Caster.CustomCast
  @moduletag :production_api_test

  @valid_attrs %{url: "https://www.youtube.com/watch?v=muFHHa370Ks"}
  @invalid_attrs %{}

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, custom_cast_path(conn, :new)
    assert html_response(conn, 200) =~ "New custom cast"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, custom_cast_path(conn, :create), custom_cast: @valid_attrs
    assert redirected_to(conn) == cast_path(conn, :index)
    assert Repo.get_by(CustomCast, @valid_attrs)
  end

  describe "playlists" do
    test "can pull in a playlist" , %{conn: conn} do
      assert 0 == custom_count
      post conn, custom_cast_path(conn, :create), custom_cast: %{url: "https://www.youtube.com/watch?list=PLScaCf_GlyyUPP9fztZDELeCjnVHmNTPd&v=y-AmyMNlYAc"}
      assert 5 == custom_count

      post conn, custom_cast_path(conn, :create), custom_cast: %{url: "https://www.youtube.com/watch?list=PLScaCf_GlyyUPP9fztZDELeCjnVHmNTPd&v=y-AmyMNlYAc"}
      assert 5 == custom_count
    end
  end

  defp custom_count do
    Caster.Cast
    |> where([source: "customcast"])
    |> Caster.Repo.all
    |> Enum.count
  end
end
