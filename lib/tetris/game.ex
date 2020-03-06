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

  @type game  :: %__MODULE__{
                   board: board | nil,
                   active_piece: piece | nil,
                   score: integer | nil,
                   status: atom,
                   speed: integer
                 }
  @type board :: %Board{}
  @type piece :: %Piece{}

  @spec new_game(integer, integer) :: game
  def new_game(x_cells \\ 15, y_cells \\ 20) do
    %__MODULE__{board: Board.create_new(x_cells, y_cells)}
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
      {:ok, game} ->
        game
        |> set_piece_on_board
      {:error, game, "Game over"} ->
        game
        |> game_over
      {:error, game, "Invalid y movement"} ->
        game
        |> scan_rows_for_scoring_move
        |> add_new_piece_to_board
      {:error, game, _} ->
        game
    end
  end

  # Private
  @spec new_piece(game) :: piece
  defp new_piece(game) do
    Piece.create_new(game.board.x_cell_count, game.board.y_cell_count)
  end

  @spec add_initial_piece_to_board(game) :: game
  defp add_initial_piece_to_board(game) do
    %{game | active_piece: new_piece(game)}
  end

  @spec add_new_piece_to_board(game) :: game
  defp add_new_piece_to_board(game) do
    %{game | active_piece: new_piece(game)}
  end

  @spec validate_piece_placement(game, piece, atom) :: {:ok, game} | {:error, game, String.t()}
  defp validate_piece_placement(game, piece, direction) do
    # Game state with old active_piece removed
    g1 = remove_piece_from_board(game)

    # Existing cells the piece would move onto
    existing_cells = board_cells_from_piece_coords(g1.board, piece)

    out_of_x_bounds? = Enum.any?(piece.coords, fn c -> c.x < 0 or c.x > g1.board.x_cell_count end)
    out_of_y_floor? = Enum.any?(piece.coords, fn c -> c.y < 0 end)
    at_y_ciel? = Enum.any?(piece.coords, fn c -> c.y >= g1.board.y_cell_count end)
    already_occupied_by_another_piece? = Enum.any?(existing_cells, fn c -> c.color !== game.board.cell_color end)
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
    updated_board = Board.update_cells(game.board, update_cells)
    %{game | board: updated_board}
  end

  @spec remove_piece_from_board(game) :: game
  defp remove_piece_from_board(game) do
    %{board: b, active_piece: p} = game

    update_cells = board_cells_from_piece_coords(b, p) |> Enum.map(fn c -> %{c | color: game.board.cell_color} end)
    updated_board = Board.update_cells(game.board, update_cells)
    %{game | board: updated_board}
  end

  @spec board_cells_from_piece_coords(board, piece) :: [map]
  defp board_cells_from_piece_coords(board, piece) do
    Enum.filter(Board.get_cells(board), fn c ->
      piece.coords |> Enum.any?(fn pc -> Board.is_cell?(c, pc) end)
    end)
  end

  @spec game_over(game) :: game
  defp game_over(game) do
    IO.puts("GAME OVER")
    %{game | status: :closed}
  end

  @spec increment_game_score(game) :: game
  defp increment_game_score(game) do
    %{game | score: game.score + 100}
  end

  @spec scan_rows_for_scoring_move(game) :: game
  defp scan_rows_for_scoring_move(game) do
    game |> scan_rows_for_scoring_move(game.board.rows)
  end
  defp scan_rows_for_scoring_move(game, []), do: game
  defp scan_rows_for_scoring_move(game, [{row_index, cells} | rows]) do
    scoring_move? = cells |> Enum.all?(fn c -> c.color !== game.board.cell_color end)

    if scoring_move? do
      updated_game = %{
        game |> increment_game_score |
        board: Board.remove_scoring_row_and_adjust(game.board, row_index)}

      scan_rows_for_scoring_move(updated_game)
    else
      scan_rows_for_scoring_move(game, rows)
    end
  end
end
