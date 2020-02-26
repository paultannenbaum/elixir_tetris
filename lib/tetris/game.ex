defmodule Tetris.Game do
  @moduledoc """
  Game context holds all the business logic for game play. This includes board state management, piece movement, and scoring
  """

  alias Tetris.Game.Board
  alias Tetris.Game.Piece

  @type board :: %Board{}
  @type piece :: %Piece{}

  @spec new_board(integer, integer) :: board
  def new_board(x \\ 25, y \\ 30) do
    Board.create_new(x, y)
  end

  @spec new_piece(board) :: piece
  def new_piece(board) do
    Piece.create_new(board.x_max, board.y_max)
  end

  # TODO: Handle failure state
  def add_new_piece_to_board(board) do
    piece = new_piece(board)

    case set_piece_on_board(board, piece) do
      {:ok, {board, piece}} -> {:ok, {board, piece}}
      {:error, msg } -> IO.puts('Handle failure case')
    end
  end

  # TODO: Handle failure state
  def move_piece_down(board, piece) do
    {_, {b1, _}} = board |> remove_piece_from_board(piece)
    p1 = Piece.down(piece)
    {_, {b2, p2}} = set_piece_on_board(b1, p1)

    {:ok, {b2, p2}}
  end

  # TODO: Handle failure state
  defp set_piece_on_board(board, piece) do
    updated_cells = Enum.map(board.cells, fn c ->
      if (Enum.member?(piece.coords, Map.take(c, [:x, :y]))) do
        %{c | color: piece.color}
      else
        c
      end
    end)

    {:ok, {%{board | cells: updated_cells}, piece}}
  end

  # TODO: Handle failure state
  defp remove_piece_from_board(board, piece) do
    updated_cells = Enum.map(board.cells, fn c ->
      if (Enum.member?(piece.coords, Map.take(c, [:x, :y]))) do
        %{c | color: :white}
      else
        c
      end
    end)

    {:ok, {%{board | cells: updated_cells}, piece}}
  end
end
