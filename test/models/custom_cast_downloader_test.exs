defmodule Caster.CustomCastDownloaderTest do
  use Caster.ModelCase
  @moduletag :production_api_test

  alias Caster.CustomCastDownloader
  alias Caster.CustomCast
  alias Caster.Cast

  test "can fetch a title correctly from youtube" do
    { :ok, title } = CustomCastDownloader.ProdClient.get_title(%CustomCast{url: "https://www.youtube.com/watch?v=muFHHa370Ks"})

    assert title == "falklands south georgia antarctica timelapse"
  end

  test "can fetch playlist information" do
    info = CustomCastDownloader.ProdClient.get_info(%{url: "https://www.youtube.com/watch?list=PLScaCf_GlyyUPP9fztZDELeCjnVHmNTPd&v=y-AmyMNlYAc"})
    assert info["_type"] == "playlist"
  end

  test "has the correct filename and directory path" do
    { :ok, filename } = CustomCastDownloader.ProdClient.get_filepath(%Cast{url: "https://www.youtube.com/watch?v=muFHHa370Ks"})

    filename_expected = Path.expand('downloads/custom/muFHHa370Ks_falklands_south_georgia_antarctica_timelapse-muFHHa370Ks.mp4', Application.app_dir(:caster, "priv"))
    assert filename == filename_expected
  end
end
