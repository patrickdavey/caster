defmodule Caster.Feed.RailsCastFeedTest do
  use Caster.ModelCase

  alias Caster.Feed.RailsCastFeed

  test "creates a RailsCast entry correctly" do
    RailsCastFeed.fetch!(Caster.Feed.RailsCastFeed.TestClient)
    video_count = Repo.one(from v in Caster.RailsCast, select: count(v.id))
    assert video_count == 1
  end

  test "only inserts the entry once if fetched multiple times" do
    RailsCastFeed.fetch!(Caster.Feed.RailsCastFeed.TestClient)
    RailsCastFeed.fetch!(Caster.Feed.RailsCastFeed.TestClient)
    video_count = Repo.one(from v in Caster.RailsCast, select: count(v.id))
    assert video_count == 1
  end
end
