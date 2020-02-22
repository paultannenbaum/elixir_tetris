defmodule Tetris.Board do
  defstruct board_status: 'closed', score: 0, cells: []

  def generate_board_cells(num_x \\ 25, num_y \\ 30) do
     for x <- 0..num_x,
         y <- 0..num_y,
     do: %{x: x, y: y, color: 'white'}
  end

  def update_cell_color(board, coord, color) do
    updated_cells = board.cells
    |> Enum.map(fn cell ->
      if (cell.x === coord.x and cell.y === coord.y) do
        %{cell | color: color}
      else
        cell
      end
    end)

    %{board | cells: updated_cells}
  end
end