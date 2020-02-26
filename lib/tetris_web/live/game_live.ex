defmodule TetrisWeb.GameLive do
  use Phoenix.LiveView

  alias Tetris.Game
  alias TetrisWeb.GameView

  @default_state %{board: nil, active_piece: nil}
  @speed 400

  def mount(_params, _session, socket) do
    state = %{@default_state | board: Game.new_board()}
    socket = assign(socket, state)

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
    {:ok, {b1, p1}} = Game.add_new_piece_to_board(socket.assigns.board)
    socket = assign(socket, board: b1, active_piece: p1)

    Process.send(self(), :game_loop, [])
    {:noreply, socket}
  end

  def handle_info(:game_loop, socket) do
    %{board: b1, active_piece: p1} = socket.assigns

    # TODO: handle_different states
    {b2, p2} = case Game.move_piece_down(b1, p1) do
      {:ok, {b, p}} -> {b, p}
    end

    Process.send_after(self(), :game_loop, @speed)
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