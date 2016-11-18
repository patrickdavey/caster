defmodule Caster.CastChannel do
  use Caster.Web, :channel

  def join("cast:lobby", payload, socket) do
    if authorized?(payload) do
       :timer.send_interval(5000, :ping)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (cast:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_info(:ping, socket) do
    push socket, "new:msg", %{user: "SYSTEM", body: "ping"}
    {:noreply, socket}
   end
  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
