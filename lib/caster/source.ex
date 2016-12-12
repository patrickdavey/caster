defmodule Caster.Source do
  defstruct [:source, :title, :refreshable, :order]
  @enforce_keys [:source, :title]
end
