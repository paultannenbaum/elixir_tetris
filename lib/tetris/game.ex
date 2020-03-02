defmodule Tetris.Game do
  @moduledoc """
    Game context holds all the business logic for game play. This includes board state management,
    piece movement, and scoring
  """

  defstruct board: nil,
            active_piece: nil,
            score: 0,
            status: :closed,
            speed: 400

  alias Tetris.Game.Board
  alias Tetris.Game.Piece

  @type game  :: %__MODULE__{}
  @type board :: %Board{}
  @type piece :: %Piece{}

  @x_cells 25
  @y_cells 30

  @spec new_game() :: game
  def new_game() do
    %__MODULE__{board: Board.create_new(@x_cells, @y_cells)}
  end

  @spec start_game(game) :: game
  def start_game(game) do
    g1 = add_new_piece_to_board(game) |> Map.merge(%{status: :open})
    {:ok, g2} = set_piece_on_board(g1)
    g2
  end

  # TODO: Handle failure state
  @spec move_piece(game, atom) :: game
  def move_piece(game, direction) do
    # New piece state
    p1 = apply(Piece, direction, [game.active_piece])

    # Validate new state
    case validate_piece_placement(game, p1, direction) do
      {:ok, g1} ->
        {:ok, g2} = set_piece_on_board(g1)
        g2
      {:error, g1, "Game Over"} ->
        game_over(g1)
      {:error, g1, "Invalid y movement"} ->
        add_new_piece_to_board(g1)
      {:error, g1, _} -> g1
    end
  end

  # Private
  defp add_new_piece_to_board(game) do
    %{game | active_piece: Piece.create_new(@x_cells, @y_cells)}
  end

  defp validate_piece_placement(game, piece, direction) do
    # Game state with old active_piece removed
    {:ok, g1} = remove_piece_from_board(game)

    # Existing cells the piece would move onto
    existing_cells = board_cells_from_piece_coords(g1.board, piece)

    out_of_x_bounds? = Enum.any?(piece.coords, fn c -> c.x < 0 or c.x > @x_cells end)
    out_of_y_floor? = Enum.any?(piece.coords, fn c -> c.y < 0 end)
    out_of_y_ciel? = Enum.any?(piece.coords, fn c -> c.y > @y_cells end)
    already_occupied_by_another_piece? = Enum.any?(existing_cells, fn c -> c.color !== :white end)
    x_move? = (direction === :left or direction === :right)
    y_move? = direction === :down

    # Test various failure scenarios, otherwise return updated board
    cond do
      out_of_y_ciel? -> {:error, game, "Game over"}
      out_of_x_bounds? -> {:error, game, "Invalid x movement"}
      out_of_y_floor? -> {:error, game, "Invalid y movement"}
      already_occupied_by_another_piece? and x_move? ->
        {:error, game, "Invalid x movement"}
      already_occupied_by_another_piece? and y_move? ->
        {:error, game, "Invalid y movement"}
      true ->
        g2 = Map.merge(game, %{
          board: g1.board,
          active_piece: piece
        })
        {:ok, g2}
    end
  end

  # TODO: Handle failure state
  @spec set_piece_on_board(game) :: atom
  defp set_piece_on_board(game) do
    %{board: b, active_piece: p} = game

    update_cells = board_cells_from_piece_coords(b, p) |> Enum.map(fn c -> %{c | color: p.color} end)
    b1 = update_board_cells(b, update_cells)
    g1 = %{game | board: b1}

    {:ok, g1}
  end

  # TODO: Handle failure state
  @spec remove_piece_from_board(game) :: atom
  defp remove_piece_from_board(game) do
    %{board: b, active_piece: p} = game

    update_cells = board_cells_from_piece_coords(b, p) |> Enum.map(fn c -> %{c | color: :white} end)
    b1 = update_board_cells(b, update_cells)
    g1 = %{game | board: b1}

    {:ok, g1}
  end

  # Returns the cells in a board that a piece would occupy
  @spec board_cells_from_piece_coords(board, piece) :: [map]
  defp board_cells_from_piece_coords(board, piece) do
    pxy = Enum.map(piece.coords, fn %{x: x, y: y} -> %{x: x, y: y} end)
    Enum.filter(board.cells, fn c -> Enum.member?(pxy, Map.take(c, [:x, :y]))end)
  end

  # Updates the matching cells in a board with the provided updates cells
  @spec update_board_cells(board, [map]) :: board
  defp update_board_cells(board, update_cells) do
    %{board | cells: Enum.map(board.cells, fn c ->
      update_cell = Enum.find(update_cells, fn(uc) -> uc.x === c.x && uc.y === c.y end)
      if (update_cell), do: update_cell, else: c
    end)}
  end

  defp game_over(game) do
    %{game | status: :closed}
  end
end
