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

  test "sorted/1 sorts by published_at" do
    Repo.insert!(%VimCast{title: "happy", url: "a", published_at: Timex.shift(Timex.now, days: -22)})
    Repo.insert!(%VimCast{title: "tyrion", url: "a", published_at: Timex.now})
    Repo.insert!(%VimCast{title: "lucky", url: "a", published_at: Timex.shift(Timex.now, days: -10)})
    Repo.insert!(%VimCast{title: "grumpy", url: "a", published_at: Timex.shift(Timex.now, days: -5)})

    query = VimCast |> VimCast.sorted
    query = from c in query, select: c.title
    assert Repo.all(query) == ~w(tyrion grumpy lucky happy)
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
