defmodule Tetris.Game do
  @moduledoc """
  Game context holds all the business logic for game play. This includes board state management, piece movement, and scoring
  """

  alias Tetris.Board

  @spec new_board(integer, integer) :: %Board{}
  def new_board(x \\ 25, y \\ 30) do
    %Board{board_status: 'open', cells: Board.generate_board_cells(x, y)}
  end

  # Temp function, testing to see if this approach works
  @spec update_board_coord(%Board{}, map, atom) :: %Board{}
  def update_board_coord(%Board{} = board, coord, color) do
    Board.update_cell_color(board, coord, color)
  end
end
