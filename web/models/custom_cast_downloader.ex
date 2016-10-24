defmodule Caster.CustomCastDownloader do
  alias Caster.CustomCast

  @download_subdirectory "custom"

  @moduledoc """
  This is the model for fetching records from youtubedl

  """

  def get_title(%CustomCast{url: url}) do
    { title, 0 } = System.cmd("youtube-dl", ["-e", url])
    { :ok, String.trim_trailing(title) }
  end

  def get_filepath(%CustomCast{url: url}) do
    { filepath, 0 } = System.cmd("youtube-dl", ["--restrict-filenames", "--get-filename", url])
    filepath = Path.expand("#{Application.get_env(:caster, :root_downloads_directory)}/#{@download_subdirectory}/#{String.trim_trailing(filepath)}", Application.app_dir(:caster, "priv"))
    { :ok, filepath}
  end

  def download!(cast = %CustomCast{url: url}) do
    { :ok, filepath } = get_filepath(cast)
    Mix.Generator.create_directory(Path.dirname(filepath))
    System.cmd("youtube-dl", ["-o", filepath,  url])
  end

end
