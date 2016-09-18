defmodule Caster.Feed.VimCastFeedTest do
  use Caster.ModelCase

  alias Caster.Feed.VimCastFeed

  test "creates a VimCast entry correctly" do
    VimCastFeed.fetch!
    video_count = Repo.one(from v in Caster.VimCast, select: count(v.id))
    assert video_count == 1
  end
end
