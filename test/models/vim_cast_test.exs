defmodule Caster.VimCastTest do
  use Caster.ModelCase

  alias Caster.VimCast

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = VimCast.changeset(%VimCast{}, valid_attributes)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = VimCast.changeset(%VimCast{}, %{})
    refute changeset.valid?
    assert {:title, {"can't be blank", []}} in changeset.errors
    assert {:url, {"can't be blank", []}} in changeset.errors
  end

  test "changeset sets the source correctly" do
    vimcast = insert_vimcast(valid_attributes)
    assert vimcast.source == "vimcast"
  end

  defp insert_vimcast(attrs) do
    %Caster.VimCast{}
      |> Caster.VimCast.changeset(attrs)
      |> Repo.insert!()
  end

  defp valid_attributes do
    %{
      published_at: Timex.now,
      title: "some content",
      url: "some url"
    }
  end
end
