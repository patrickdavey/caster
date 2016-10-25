defmodule Caster.CustomCastTest do
  use Caster.ModelCase

  alias Caster.CustomCast
  alias Caster.RailsCast
  alias Caster.Cast

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
    assert Cast.downloaded?(cast)
  end

  test "sorted/1 sorts by inserted_at" do
    Repo.insert!(%CustomCast{title: "lucky", url: "a", inserted_at: Ecto.DateTime.cast!("2013-04-17T14:00:00Z")})
    Repo.insert!(%CustomCast{title: "grumpy", url: "a", inserted_at: Ecto.DateTime.cast!("2014-04-17T14:00:00Z")})
    Repo.insert!(%CustomCast{title: "tyrion", url: "a", inserted_at: Ecto.DateTime.cast!("2015-04-17T14:00:00Z")})
    Repo.insert!(%CustomCast{title: "happy", url: "a", inserted_at: Ecto.DateTime.cast!("2011-04-17T14:00:00Z")})

    query = CustomCast.sorted |> CustomCast.titles
    assert Repo.all(query) == ~w(tyrion grumpy lucky happy)
  end

  test "only returns customcast models" do
    Repo.insert!(%CustomCast{title: "happy", url: "a"})
    Repo.insert!(%RailsCast{title: "worried", url: "a", episode: 1, published_at: Timex.shift(Timex.now, days: -5)})
    videos = Repo.all(CustomCast.sorted)
    assert length(videos) == 1
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
