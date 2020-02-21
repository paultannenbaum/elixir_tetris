defmodule Tetris.Board do
  defstruct state: 'playing', score: 0, cells: []

  def new_board do
    %Tetris.Board{cells: generate_board_cells()}
  end

  defp generate_board_cells(num_x \\ 50, num_y \\ 60) do
     for x <- 0..num_x,
         y <- 0..num_y,
     do: %{x: x, y: y, color: 'white'}
  end
end