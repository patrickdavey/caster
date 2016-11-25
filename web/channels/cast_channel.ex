defmodule Caster.CastChannel do
  @moduledoc """
    Channel for sending messages about downloading back
    to the client

    Currently a one-way broadcast of data, not expecing
    to really communicate over it.
  """

  use Caster.Web, :channel

  def join("casts:cast" <> _cast_id, _params, socket) do
    {:ok, socket}
  end
end
