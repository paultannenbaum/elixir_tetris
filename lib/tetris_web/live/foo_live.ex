defmodule TetrisWeb.FooLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    IO.inspect(socket)
    {:ok, assign(socket, msg: "test")}
  end

  def render(assigns) do
    ~L"""
    <h1>Hello!</h1>
    <div phx-window-keydown="keydown">
    <%= @msg %>
    </div>
    """
  end

  def handle_event("keydown", %{"key" => key}, socket) do
    {:noreply, assign(socket, msg: key)}
  end
end