defmodule TetrisWeb.PageView do
  use TetrisWeb, :view

  @num_x_cells 40
  @num_y_cells 80

  def create_board_cells do
    cell_list = for x <- 0..@num_x_cells,
                    y <- 0..@num_y_cells,
                    do: {x,y}

    cell_list
    |> Enum.map(fn {x, y} -> content_tag :span, "x: #{x}, y: #{y}" end)
    |> html_escape
  end
end
