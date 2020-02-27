defmodule TetrisWeb.GameLive do
  @moduledoc """
    In charge of connecting the LiveView to the DOM, handling events and translating events
    into actions taken by the Game context. No actual game logic should be handled by this module,
    instead this should be pushed into the Game context.
  """

  use Phoenix.LiveView

  alias Tetris.Game
  alias TetrisWeb.GameView

  def mount(_params, _session, socket) do
    socket = assign(socket, game: Game.new_game())
    if connected?(socket), do: Process.send(self(), :game_start, [])
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1 phx-click="move_left">New Game</h1>
    <div phx-click="rotate_clockwise" id="game-board" >
      <%= GameView.board_as_html(@game.board) %>
    </div>
    """
  end

  def handle_info(:game_start, socket) do
    game = socket.assigns.game
    Process.send(self(), :game_loop, [])
    {:noreply, assign(socket, game: Game.start_game(game))}
  end

  def handle_info(:game_loop, socket) do
    game = socket.assigns.game
#    Process.send_after(self(), :game_loop, game.speed)
    {:noreply, assign(socket, game: Game.move_piece(game, :down))}
  end

  def handle_event("move_left", %{}, socket) do
    game = socket.assigns.game
    {:noreply, assign(socket, game: Game.move_piece(game, :left))}
  end

  def handle_event("rotate_clockwise", %{}, socket) do
    game = socket.assigns.game
    {:noreply, assign(socket, game: Game.move_piece(game, :rotate_clockwise))}
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