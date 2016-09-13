defmodule Caster.CastTest do
  use Caster.ModelCase

  alias Caster.Cast

  @valid_attrs %{episode: 42, file_location: "some content", interesting: true, name: "some content", note: "some content", source: "some content", url: "some content", viewed: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Cast.changeset(%Cast{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Cast.changeset(%Cast{}, @invalid_attrs)
    refute changeset.valid?
  end
end
