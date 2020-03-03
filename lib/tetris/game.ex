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
    game
    |> Map.merge(%{status: :open})
    |> add_initial_piece_to_board
    |> set_piece_on_board
  end

  @spec move_piece(game, atom) :: game
  def move_piece(game, direction) do
    # New piece state
    piece = apply(Piece, direction, [game.active_piece])

    scan_rows_for_scoring_move(game)

    # Validate new state
    case validate_piece_placement(game, piece, direction) do
      {:ok, game} -> set_piece_on_board(game)
      {:error, game, "Game over"} -> game_over(game)
      {:error, game, "Invalid y movement"} -> add_new_piece_to_board(game)
      {:error, game, _} -> game
    end
  end

  # Private
  @spec add_initial_piece_to_board(game) :: game
  defp add_initial_piece_to_board(game) do
    %{game | active_piece: Piece.create_new(@x_cells, @y_cells)}
  end

  @spec add_new_piece_to_board(game) :: game
  defp add_new_piece_to_board(game) do
    %{game | active_piece: Piece.create_new(@x_cells, @y_cells+1)}
  end

  @spec validate_piece_placement(game, piece, atom) :: atom
  defp validate_piece_placement(game, piece, direction) do
    # Game state with old active_piece removed
    g1 = remove_piece_from_board(game)

    # Existing cells the piece would move onto
    existing_cells = board_cells_from_piece_coords(g1.board, piece)

    out_of_x_bounds? = Enum.any?(piece.coords, fn c -> c.x < 0 or c.x > @x_cells end)
    out_of_y_floor? = Enum.any?(piece.coords, fn c -> c.y < 0 end)
    at_y_ciel? = Enum.any?(piece.coords, fn c -> c.y >= @y_cells end)
    already_occupied_by_another_piece? = Enum.any?(existing_cells, fn c -> c.color !== :white end)
    x_move? = (direction === :left or direction === :right)
    y_move? = direction === :down

    # Test various failure scenarios, otherwise return updated board
    cond do
      already_occupied_by_another_piece? and at_y_ciel?  -> {:error, game, "Game over"}
      out_of_x_bounds? -> {:error, game, "Invalid x movement"}
      out_of_y_floor? -> {:error, game, "Invalid y movement"}
      already_occupied_by_another_piece? and x_move? ->
        {:error, game, "Invalid x movement"}
      already_occupied_by_another_piece? and y_move? ->
        {:error, game, "Invalid y movement"}
      true ->
        {:ok, Map.merge(game, %{
          board: g1.board,
          active_piece: piece
        })}
    end
  end

  @spec set_piece_on_board(game) :: game
  defp set_piece_on_board(game) do
    %{board: b, active_piece: p} = game

    update_cells = board_cells_from_piece_coords(b, p) |> Enum.map(fn c -> %{c | color: p.color} end)
    updated_board = update_board_cells(b, update_cells)
    %{game | board: updated_board}
  end

  @spec remove_piece_from_board(game) :: game
  defp remove_piece_from_board(game) do
    %{board: b, active_piece: p} = game

    update_cells = board_cells_from_piece_coords(b, p) |> Enum.map(fn c -> %{c | color: :white} end)
    updated_board = update_board_cells(b, update_cells)
    %{game | board: updated_board}
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

  @spec game_over(game) :: game
  defp game_over(game) do
    IO.puts("GAME OVER")
    %{game | status: :closed}
  end

  defp scan_rows_for_scoring_move(game) do
    scoring_rows =
      Board.cells_to_row_map(game.board.cells)
      |> Enum.filter(fn {row_num, cells} -> Enum.all?(cells, fn c -> c.color !== :white end) end)

    IO.inspect(scoring_rows)
  end
end
