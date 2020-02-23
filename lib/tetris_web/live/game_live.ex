defmodule TetrisWeb.GameLive do
  use Phoenix.LiveView

  import Phoenix.HTML.Tag
  alias Tetris.Game

  def mount(_params, _session, socket) do
    {:ok, assign(socket, board: Game.new_board())}
  end

  def render(assigns) do
    ~L"""
    <h1>New Game</h1>
    <div id="game-board">
      <%= board_as_html(@board) %>
    </div>
    """
  end

  def handle_event("keydown", %{"key" => key}, socket) do
    {:noreply, assign(socket, msg: key)}
  end

  def board_as_html(board) do
    board.cells
    |> Enum.sort(&(&1.y >= &2.y))
    |> Enum.map(fn %{x: x, y: y, color: color} ->
      content_tag :span, "", [{:data, [x: x]}, {:data, [y: y]}, class: "cell #{color}"] end)
  end
end