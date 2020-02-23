defmodule TetrisWeb.GameView do
  use TetrisWeb, :view

  # translates board object into something the DOM can understand
  def board_as_html(board) do
    board.cells
    |> Enum.sort(&(&1.y >= &2.y))
    |> Enum.map(fn %{x: x, y: y, color: color} ->
      content_tag :span, "", [{:data, [x: x]}, {:data, [y: y]}, class: "cell #{color}"] end)
  end
end
