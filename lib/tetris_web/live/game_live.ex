defmodule TetrisWeb.GameLive do
  use Phoenix.LiveView

  alias Tetris.Game
  alias TetrisWeb.GameView

  def mount(_params, _session, socket) do
    socket = assign(socket, board: Game.new_board())

    if connected?(socket), do: Process.send(self(), :game_start, [])
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>New Game</h1>
    <div id="game-board">
      <%= GameView.board_as_html(@board) %>
    </div>
    """
  end

  def handle_info(:game_start, socket) do
    Process.send(self(), :game_loop, [])
    {:noreply, socket}
  end

  def handle_info(:game_loop, socket) do
    Process.send_after(self(), :game_loop, 1000)

    b1 = socket.assigns.board
    random_cell = b1.cells
                |> Enum.filter(fn x -> x.color === :white end)
                |> Enum.random
#    b2 = Game.update_board_coord(b1, random_cell, :black)

    # compute next state


    # validate next state
    # render next state

    {:noreply, assign(socket, board: b1)}
  end

#  def handle_event("game_start", %{}, socket) do
#
#    # {:noreply, assign(socket, msg: key)}
#  end
#
#  def handle_event("game_end", %{}, socket) do
#  end
#
#  def handle_event("piece_down", %{}, socket) do
#  end
#
#  def handle_event("piece_left", %{}, socket) do
#  end
#
#  def handle_event("piece_right", %{}, socket) do
#  end
#
#  def handle_event("rotate_piece_clockwise", %{}, socket) do
#  end
#
#  def handle_event("rotate_piece_counter_clockwise", %{}, socket) do
#  end
end