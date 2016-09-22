defmodule Caster.CustomCastDownloader do
  alias Caster.CustomCast

  @moduledoc """
  This is the model for fetching records from youtubedl

  """

  def fetch(%CustomCast{url: url}) do
    { title, 0 } = System.cmd("youtube-dl", ["-e" | [url]])

    { :ok, String.trim_trailing(title) }
  end

end
