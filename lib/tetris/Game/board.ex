defmodule Tetris.Game.Board do
  defstruct cells: []

  @type board :: %__MODULE__{ cells: [map] }

  @spec create_new(integer, integer) :: board
  def create_new(x, y) do
    %__MODULE__{
      cells: generate_board_cells(x, y)
    }
  end

  @spec generate_board_cells(integer, integer) :: [map]
  defp generate_board_cells(x_max, y_max) do
    for x <- 0..x_max,
        y <- 0..y_max,
        do: %{x: x, y: y, color: :white}
  end
end