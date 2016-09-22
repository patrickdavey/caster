defmodule Caster.CustomCastDownloaderTest do
  use Caster.ModelCase
  @moduletag :production_api_test

  alias Caster.CustomCastDownloader
  alias Caster.CustomCast

  test "can fetch a title correctly from youtube" do
    { :ok, title } = CustomCastDownloader.fetch(%CustomCast{url: "https://www.youtube.com/watch?v=muFHHa370Ks"})

    assert title == "falklands south georgia antarctica timelapse"
  end

  test "has the correct filename path" do
    { :ok, filename } = CustomCastDownloader.get_filename(%CustomCast{url: "https://www.youtube.com/watch?v=muFHHa370Ks"})

    assert filename == ""
  end
end
