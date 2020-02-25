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

  #  @spec set_piece_coords_on_board(board, piece) :: board


  #  @spec move_piece_down(%Board{}, %Piece{}) :: atom
  #  def move_piece_down(board, piece) do
  #
  #  end
end
