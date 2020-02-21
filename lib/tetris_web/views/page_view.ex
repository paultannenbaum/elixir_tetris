defmodule TetrisWeb.PageView do
  use TetrisWeb, :view

  @x_cells 40
  @y_cells 80

  def create_board_cells(num_wide \\ @x_cells, num_tall \\ @y_cells) do
    cell_list = for y <- num_tall..0,
                    x <- 0..num_wide,
                    do: {x,y}

    cell_list
    |> Enum.map(fn {x, y} -> content_tag :span, "", [{:data, [x: x]}, {:data, [y: y]}, class: "cell"] end)
    |> html_escape
  end
end
