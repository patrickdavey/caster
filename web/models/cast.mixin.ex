defmodule Caster.Cast.Mixin do
  @moduledoc """
    Used to share common queries between Cast structs
  """

  defmacro __using__(_params) do
    quote do
      def titles(query) do
        from c in query, select: c.title
      end
      def sorted do
        raise "should be overridden"
      end
      defoverridable [sorted: 0]
    end
  end
end
