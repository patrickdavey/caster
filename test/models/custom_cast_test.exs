defmodule Caster.CustomCastTest do
  use Caster.ModelCase

  alias Caster.CustomCast
  alias Caster.RailsCast

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CustomCast.changeset(%CustomCast{}, valid_attributes)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CustomCast.changeset(%CustomCast{}, %{})
    refute changeset.valid?
    assert {:title, {"can't be blank", []}} in changeset.errors
    assert {:url, {"can't be blank", []}} in changeset.errors
  end

  test "changeset sets the source correctly" do
    customcast = insert_customcast(valid_attributes)
    assert customcast.source == "customcast"
  end

  test "if there is a filename it is downloaded" do
    cast = Repo.insert!(%CustomCast{title: "lucky", url: "a", file_location: "blah"})
    assert Caster.Cast.downloaded?(cast)
  end

  defp insert_customcast(attrs) do
    %Caster.CustomCast{}
      |> Caster.CustomCast.changeset(attrs)
      |> Repo.insert!()
  end

  defp valid_attributes do
    %{
      title: "some content",
      url: "some url"
    }
  end
end
