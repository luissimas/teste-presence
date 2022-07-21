defmodule PokerplanningWeb.PageLive do
  use PokerplanningWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("join_room", %{"join" => %{"username" => username, "room" => room_id}}, socket) do
    {:noreply, push_redirect(socket, to: "/room/#{room_id}?user=#{username}")}
  end

  def handle_params(_params, _, socket), do: {:noreply, socket}

  @impl true
  def render(assigns) do
    ~H"""
    <.form let={f} for={:join} phx-submit="join_room">
      <%= label f, :username %>
      <%= text_input f, :username %>
      <%= error_tag f, :username %>

      <%= label f, :room %>
      <%= text_input f, :room %>
      <%= error_tag f, :room %>

      <%= submit "Join" %>
    </.form>
    """
  end
end
