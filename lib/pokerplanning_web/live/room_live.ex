defmodule PokerplanningWeb.RoomLive do
  use PokerplanningWeb, :live_view
  alias PokerplanningWeb.Presence

  @impl true
  def mount(%{"id" => room_id, "user" => username}, _session, socket) do
    topic = topic(room_id)
    Presence.track(self(), topic, username, %{username: username, vote: nil})

    PokerplanningWeb.Endpoint.subscribe(topic)

    users = room_users(room_id)

    {:ok,
     socket
     |> assign(:room_id, room_id)
     |> assign(:username, username)
     |> assign(:users, users)}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    users = room_users(socket.assigns.room_id)

    {:noreply,
     socket
     |> assign(:users, users)}
  end

  @impl true
  def handle_event(
        "vote",
        %{"vote" => vote},
        %{assigns: %{room_id: room_id, username: username}} = socket
      ) do
    topic = topic(room_id)

    user_metas =
      topic
      |> Presence.get_by_key(username)
      |> Map.get(:metas)
      |> List.first()
      |> Map.merge(%{vote: vote})

    Presence.update(self(), topic, username, user_metas)

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h2>Sala: <%= @room_id %></h2>
    <p>Usuários: </p>
    <%= for user <- @users do%>
      <li><%= user.username %>: <%= user.vote %></li>
    <% end %>
    <button phx-click="vote" phx-value-vote="1">1</button>
    <button phx-click="vote" phx-value-vote="3">3</button>
    <button phx-click="vote" phx-value-vote="5">5</button>
    """
  end

  defp topic(room_id), do: "room:#{room_id}"

  defp room_users(room_id) do
    room_id
    |> topic()
    |> Presence.list()
    |> Enum.filter(fn {key, _value} -> key != room_id end)
    |> Enum.map(fn {_key, value} ->
      value.metas |> List.first()
    end)
  end
end
