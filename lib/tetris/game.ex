defmodule Tetris.Game do
  @moduledoc """
    Game context holds all the business logic for game play. This includes board state management,
    piece movement, and scoring
  """

  defstruct board: nil,
            active_piece: nil,
            score: nil,
            status: :closed,
            speed: 400

  alias Tetris.Game.Board
  alias Tetris.Game.Piece

  @type game  :: %__MODULE__{}
  @type board :: %Board{}
  @type piece :: %Piece{}

  @x_cells 10
  @y_cells 20

  @spec new_game() :: game
  def new_game() do
    %__MODULE__{board: Board.create_new(@x_cells, @y_cells)}
  end

  @spec start_game(game) :: game
  def start_game(game) do
    game
    |> Map.merge(%{status: :open, score: 0})
    |> add_initial_piece_to_board
    |> set_piece_on_board
  end

  @spec move_piece(game, atom) :: game
  def move_piece(game, direction) do
    # New piece state
    piece = apply(Piece, direction, [game.active_piece])

    # Validate new state
    case validate_piece_placement(game, piece, direction) do
      {:ok, game} -> game |> set_piece_on_board
      {:error, game, "Game over"} -> game |> game_over
      {:error, game, "Invalid y movement"} -> game |> scan_rows_for_scoring_move |> add_new_piece_to_board
      {:error, game, _} -> game
    end
  end

  # Private
  @spec new_piece() :: piece
  defp new_piece() do
    Piece.create_new(@x_cells, @y_cells)
  end

  @spec add_initial_piece_to_board(game) :: game
  defp add_initial_piece_to_board(game) do
    %{game | active_piece: new_piece()}
  end

  @spec add_new_piece_to_board(game) :: game
  defp add_new_piece_to_board(game) do
    %{game | active_piece: new_piece()}
  end

  @spec validate_piece_placement(game, piece, atom) :: atom
  defp validate_piece_placement(game, piece, direction) do
    # Game state with old active_piece removed
    g1 = remove_piece_from_board(game)

    # Existing cells the piece would move onto
    existing_cells = board_cells_from_piece_coords(g1.board, piece)

    out_of_x_bounds? = Enum.any?(piece.coords, fn c -> c.x < 0 or c.x > g1.board.x_cell_count end)
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

  defp increment_game_score(game) do
    %{game | score: game.score + 100}
  end

  defp remove_scoring_row(game, row_key) do
    updated_cells =
      game.board.cells
      |> Board.cells_by_row
      |> Enum.filter(fn {r_key, _} -> r_key !== row_key end)
      |> Enum.map(fn {r_key, cells} ->
        IO.inspect(cells)
        if (r_key > row_key) do
          updated_cells = Enum.map(cells, fn c -> %{c | y: c.y - 1 } end)
          {r_key, updated_cells}
        else
          {r_key, cells}
        end
      end)
      |> Board.cells_by_row_unfolded

    %{game | board: %{game.board | cells: updated_cells}}
  end

  defp scan_rows_for_scoring_move(game) do
    rows = game.board.cells |> Board.cells_by_row
    game |> scan_rows_for_scoring_move(rows)
  end
  defp scan_rows_for_scoring_move(game, []), do: game
  defp scan_rows_for_scoring_move(game, [{row_key, cells} | rows]) do
    scoring_move? = cells |> Enum.all?(fn c -> c.color !== :white end)

    if scoring_move? do
      updated_game = game |> remove_scoring_row(row_key) |> increment_game_score
      scan_rows_for_scoring_move(updated_game)
    else
      scan_rows_for_scoring_move(game, rows)
    end
  end
end
