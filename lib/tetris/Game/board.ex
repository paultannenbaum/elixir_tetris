defmodule Tetris.Game.Board do
  defstruct cells: []

  @type board :: %__MODULE__{ cells: [map] }

  @spec create_new(integer, integer) :: board
  def create_new(x, y) do
    %__MODULE__{
      cells: generate_board_cells(x, y)
    }
  end

  def cells_to_row_map(cells) do
    cells
    |> Enum.reduce(%{}, fn c, acc ->
      {_, updated} = Map.get_and_update(acc, c.y, fn row ->
        updated_row = if row, do: [c | row], else: [c]
        {row, updated_row}
      end)

      updated
    end)
  end

  def row_map_to_cells(row_map) do
    row_map
    |> Enum.reduce([], fn {row, cells}, acc -> acc ++ cells end)
  end

  @spec generate_board_cells(integer, integer) :: [map]
  defp generate_board_cells(x_max, y_max) do
    for x <- 0..x_max,
        y <- 0..y_max,
        do: %{x: x, y: y, color: :white}
  end
end