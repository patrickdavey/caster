defmodule Caster.CustomCastDownloaderTest do
  use Caster.ModelCase
  @moduletag :production_api_test

  alias Caster.CustomCastDownloader

  test "can fetch a title correctly from youtube" do
    { title, 0 } = CustomCastDownloader.fetch("https://www.youtube.com/watch?v=muFHHa370Ks")

    title = String.trim_trailing(title)
    assert title == "falklands south georgia antarctica timelapse"
  end
end
