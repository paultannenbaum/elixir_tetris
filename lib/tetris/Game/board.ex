defmodule Tetris.Game.Board do
  defstruct board_status: :closed,
            score: 0,
            cells: [],
            x_max: 0,
            y_max: 0
  @type board :: %__MODULE__{
               board_status: atom,
               score: integer,
               cells: [map],
               x_max: integer,
               y_max: integer
             }


  @spec create_new(integer, integer) :: board
  def create_new(x_max, y_max) do
    %__MODULE__{
      x_max: x_max,
      y_max: y_max,
      cells: generate_board_cells(x_max, y_max),
      board_status: :open
    }
  end


  @spec generate_board_cells(integer, integer) :: [map]
  defp generate_board_cells(x_max, y_max) do
    for x <- 0..x_max,
        y <- 0..y_max,
        do: %{x: x, y: y, color: :white}
  end
end