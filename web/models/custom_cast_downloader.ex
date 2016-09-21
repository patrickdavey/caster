defmodule Caster.CustomCastDownloader do
  @moduledoc """
  This is the model for fetching records from youtubedl

  """

  def fetch(url) do
    System.cmd("youtube-dl", ["-e" | [url]])
  end
end
