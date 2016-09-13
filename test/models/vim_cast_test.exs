defmodule Caster.VimCastTest do
  use Caster.ModelCase

  alias Caster.VimCast

  @valid_attrs %{name: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = VimCast.changeset(%VimCast{}, @valid_attrs)
    assert changeset.valid?
  end
end
