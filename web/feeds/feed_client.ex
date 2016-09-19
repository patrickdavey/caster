defmodule Caster.FeedClient do
  @doc "fetches data from an external source"
  @callback fetch! :: String.t
end
