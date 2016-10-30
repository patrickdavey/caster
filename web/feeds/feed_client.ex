defmodule Caster.FeedClient do
  @moduledoc """
    Used to define common behaviours which all feeds must implement
  """
  @doc "fetches data from an external source"
  @callback fetch! :: String.t
end
