defmodule TetrisWeb.GameLive do
  use Phoenix.LiveView

  alias Tetris.Game
  alias TetrisWeb.GameView

  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :game_start, 0)
    {:ok, assign(socket, board: Game.new_board())}
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
    Process.send_after(self(), :game_loop, 0)
    {:noreply, assign(socket, %{})}
  end

  def handle_info(:game_loop, socket) do
    Process.send_after(self(), :game_loop, 1000)

    # compute next state
    # validate next state
    # render next state

    {:noreply, assign(socket, %{})}
  end

  def handle_event("game_start", %{}, socket) do

    # {:noreply, assign(socket, msg: key)}
  end

  def handle_event("game_end", %{}, socket) do
  end

  def handle_event("piece_down", %{}, socket) do
  end

  def handle_event("piece_left", %{}, socket) do
  end

  def handle_event("piece_right", %{}, socket) do
  end

  def handle_event("rotate_piece_clockwise", %{}, socket) do
  end

  def handle_event("rotate_piece_counter_clockwise", %{}, socket) do
  end
end