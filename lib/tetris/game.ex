defmodule Tetris.Game do
  alias Tetris.Board

  def new_board do
    %Board{board_status: 'open', cells: Board.generate_board_cells()}
  end

  # Temp function, testing to see if this approach works
  def update_board_coord(%Board{} = board, coord, color) do
    Board.update_cell_color(board, coord, color)
  end
end
