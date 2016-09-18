defmodule Caster.VimCastTest do
  use Caster.ModelCase

  alias Caster.VimCast

  @valid_attrs %{title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = VimCast.changeset(%VimCast{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = VimCast.changeset(%VimCast{}, %{})
    refute changeset.valid?
    assert {:title, {"can't be blank", []}} in changeset.errors
    assert {:url, {"can't be blank", []}} in changeset.errors
  end

  test "changeset sets the source correctly" do
    vimcast = insert_vimcast(@valid_attrs)
    assert vimcast.source == "vimcast"
  end

  defp insert_vimcast(attrs) do
    %Caster.VimCast{}
                |> Caster.VimCast.changeset(attrs)
                |> Repo.insert!()
  end
end
