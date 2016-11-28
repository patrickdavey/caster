defmodule Caster.LocalFolder do
  defstruct [:source, :directory, :title, :wildcard_match]
  @enforce_keys [:source, :directory, :title, :wildcard_match]
end

