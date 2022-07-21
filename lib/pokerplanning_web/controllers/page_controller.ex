defmodule PokerplanningWeb.PageController do
  use PokerplanningWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
