defmodule Caster.Source do
  defstruct [:source, :title, :order, :wildcard_match, refreshable: false, removeable: true]
  @enforce_keys [:source, :title]
end
