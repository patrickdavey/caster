defmodule Caster.Feed.LiveFeedTest do
  use Caster.ModelCase
  @moduletag :production_api_test
  alias Caster.Feed.VimCastFeed

  test "fetches records from the production vimcast feed correctly" do
    VimCastFeed.fetch!
    video_count = Repo.one(from v in Caster.VimCast, select: count(v.id))
    assert video_count == 68
  end
end
