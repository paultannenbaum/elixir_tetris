defmodule TetrisWeb.GameView do
  use TetrisWeb, :view

  alias Tetris.Game
  alias Tetris.Game.Board

  @type game :: %Game{}

  # Translates Game.Board%{} into html strings
  @spec board_as_html(game) :: [String.t()]
  def board_as_html(game) do
    Board.get_cells(game.board)
    |> Enum.sort(&(&1.y >= &2.y))
    |> Enum.map(fn %{x: x, y: y, color: color} ->
      content_tag :span, "", [{:data, [x: x]}, {:data, [y: y]}, class: "cell #{to_string color}"] end)
  end

  # Calculates the total width of the board
  @spec board_width(game) :: String.t()
  def board_width(game) do
    cell_width_in_pixels = 20
    "#{(game.board.x_cell_count) * cell_width_in_pixels}px"
  end
end
