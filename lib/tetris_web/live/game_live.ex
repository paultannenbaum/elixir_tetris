defmodule TetrisWeb.GameLive do
  use Phoenix.LiveView

  alias Tetris.Game
  alias TetrisWeb.GameView

  def mount(_params, _session, socket) do
    board = Game.new_board()
    active_piece = Game.new_piece(board)

    # place the piece on the board
    updated_board = Game.set_piece_on_board(board, active_piece)

    socket = assign(socket, board: updated_board, active_piece: active_piece)

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
    Process.send_after(self(), :game_loop, 300)

    %{board: b1, active_piece: p1} = socket.assigns

    IO.inspect(socket.assigns)

    # TODO: Handle failure state
    %{board: b2, piece: p2} = Game.move_piece_down(b1, p1)

    {:noreply, assign(socket, board: b2, active_piece: p2)}
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