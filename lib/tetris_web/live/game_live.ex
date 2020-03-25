defmodule TetrisWeb.GameLive do
  @moduledoc """
    In charge of connecting the LiveView to the DOM, handling events and translating events
    into actions taken by the Game context. No actual game logic should be handled by this module,
    instead this should be pushed into the Game context.
  """
  use Phoenix.LiveView

  alias Tetris.Game
  alias TetrisWeb.GameView

  @type socket  :: %Elixir.Phoenix.LiveView.Socket{}
  @type session :: map
  @type params  :: map

  def render(assigns) do
    ~L"""
    <div id="app-container">
      <h1>Tetris</h1>

      <button
        phx-click="start_game"
        <%= if @game.status === :open, do: 'disabled'%>
      >
        Start New Game
      </button>

      <div class="game-info">
        <%= if @game.score do %>
          Score: <%= @game.score %>
        <% end %>
      </div>

      <div id="game-board"
        style="width: <%= GameView.board_width(@game) %>"
        phx-window-keydown="key_event"
      >
        <%= GameView.board_as_html(@game) %>
      </div>

      <div>
        <h4>Instructions:</h4>
          <p>
          Use the arrow keys to move the piece around the board.</br>
          Keyboard key "A" rotates the piece counter clockwise.</br>
          Keyboard key "S" rotates the piece clockwise.
          </p>
      </div>

      <%= if @game.status === :open do %>
        <span phx-click="stop_game" class="cancel-game">cancel game</span>
      <% end %>
    </div>

    """
  end

  @spec mount(params, session, socket) :: {:ok, socket}
  def mount(_params, _session, socket) do
    socket = assign(socket, game: Game.new_game())
    {:ok, socket}
  end

  @spec handle_info(atom, socket) :: {:noreply, socket}
  def handle_info(:game_loop, socket) do
    game = socket.assigns.game

    if (game.status === :open), do: Process.send_after(self(), :game_loop, game.speed)

    cond do
      Map.has_key?(socket.assigns, :game_loop_initialized) -> move_piece(socket, :down)
      true -> {:noreply, assign(socket, game_loop_initialized: true)}
    end
  end

  @spec handle_event(String.t(), params, socket) :: {:noreply, socket}
  def handle_event("start_game", _, socket) do
    Process.send(self(), :game_loop, [])
    {:noreply, assign(socket, game: Game.new_game() |> Game.start_game)}
  end

  def handle_event("stop_game", _, socket) do
    {:noreply, assign(socket, game: Game.new_game())}
  end

  def handle_event("key_event", %{"code" => "ArrowLeft"}, socket), do: move_piece(socket, :left)

  def handle_event("key_event", %{"code" => "ArrowRight"}, socket), do: move_piece(socket, :right)

  def handle_event("key_event", %{"code" => "ArrowDown"}, socket), do: move_piece(socket, :down)

  def handle_event("key_event", %{"code" => "KeyA"}, socket), do: move_piece(socket, :rotate_counter_clockwise)

  def handle_event("key_event", %{"code" => "KeyS"}, socket), do: move_piece(socket, :rotate_clockwise)

  def handle_event("key_event", _, socket),  do: {:noreply, socket}

  @spec move_piece(socket, atom) :: {:noreply, socket}
  defp move_piece(socket, move) do
    game = socket.assigns.game

    if game.status === :closed do
      {:noreply, socket}
    else
      {:noreply, assign(socket, game: game |> Game.move_piece(move))}
    end
  end
end
