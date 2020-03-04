defmodule TetrisWeb.GameView do
  use TetrisWeb, :view

  # translates board object into something the DOM can understand
  def board_as_html(game) do
    game.board.cells
    |> Enum.sort(&(&1.y >= &2.y))
    |> Enum.map(fn %{x: x, y: y, color: color} ->
      content_tag :span, "", [{:data, [x: x]}, {:data, [y: y]}, class: "cell #{to_string color}"] end)
  end

  # Calculates the total width of the board, adds 1 because cells are zero indexed
  def board_width(game) do
    cell_width_in_pixels = 20
    "#{(game.board.x_cell_count + 1) * cell_width_in_pixels}px"
  end
end
