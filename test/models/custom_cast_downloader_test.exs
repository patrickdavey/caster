defmodule Caster.CustomCastDownloaderTest do
  use Caster.ModelCase
  @moduletag :production_api_test

  alias Caster.CustomCastDownloader
  alias Caster.CustomCast

  test "can fetch a title correctly from youtube" do
    { :ok, title } = CustomCastDownloader.get_title(%CustomCast{url: "https://www.youtube.com/watch?v=muFHHa370Ks"})

    assert title == "falklands south georgia antarctica timelapse"
  end

  test "has the correct filename and directory path" do
    { :ok, filename } = CustomCastDownloader.get_filepath(%CustomCast{url: "https://www.youtube.com/watch?v=muFHHa370Ks"})
    # Caster.CustomCastDownloader.download!(%Caster.CustomCast{url: "https://www.youtube.com/watch?v=jhFDyDgMVUI"})

    filename_expected = Path.expand('downloads/custom/falklands_south_georgia_antarctica_timelapse-muFHHa370Ks.mp4', Application.app_dir(:caster, "priv"))
    assert filename == filename_expected
  end
end
