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

#  @spec set_piece_on_board(board, piece) :: {:ok, board} | {:error, t.String}
  def set_piece_on_board(board, piece) do
    # TODO: Come back and validate

    valid_cells =
      Enum.filter(board.cells, fn c -> Enum.member?(piece.coords, Map.take(c, [:x, :y]))end)
      |> Enum.all?(fn c -> c.color === :white end)

    if (valid_cells) do
      %{board | cells: Enum.map(board.cells, fn c ->
        if (Enum.member?(piece.coords, Map.take(c, [:x, :y]))) do
          %{c | color: piece.color}
        else
          c
        end
      end)}
    else
      {:error, "invalid move"}
    end
  end

  #  @spec move_piece_down(%Board{}, %Piece{}) :: atom
  #  def move_piece_down(board, piece) do
  #
  #  end
end
