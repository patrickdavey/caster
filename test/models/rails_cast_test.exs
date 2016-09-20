defmodule Caster.RailsCastTest do
  use Caster.ModelCase

  alias Caster.RailsCast

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RailsCast.changeset(%RailsCast{}, valid_attributes)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RailsCast.changeset(%RailsCast{}, %{})
    refute changeset.valid?
    assert {:title, {"can't be blank", []}} in changeset.errors
    assert {:url, {"can't be blank", []}} in changeset.errors
  end

  test "changeset sets the source correctly" do
    railscast = insert_railscast(valid_attributes)
    assert railscast.source == "railscast"
  end

  test "sorted/1 sorts by published_at" do
    Repo.insert!(%RailsCast{title: "happy", url: "a", episode: 1, published_at: Timex.shift(Timex.now, days: -5)})
    Repo.insert!(%RailsCast{title: "tyrion", url: "a", episode: 4, published_at: Timex.shift(Timex.now, days: -5)})
    Repo.insert!(%RailsCast{title: "lucky", url: "a", episode: 2, published_at: Timex.shift(Timex.now, days: -5)})
    Repo.insert!(%RailsCast{title: "grumpy", url: "a", episode: 3, published_at: Timex.shift(Timex.now, days: -5)})

    assert Repo.all(RailsCast.sorted |> RailsCast.titles) == ~w(tyrion grumpy lucky happy)
  end

  defp insert_railscast(attrs) do
    %Caster.RailsCast{}
      |> Caster.RailsCast.changeset(attrs)
      |> Repo.insert!()
  end

  defp valid_attributes do
    %{
      episode: 1,
      published_at: Timex.shift(Timex.now, days: -5),
      title: "some content",
      url: "some url"
    }
  end
end
