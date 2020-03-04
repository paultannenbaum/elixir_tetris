defmodule Tetris.Game.Board do
  defstruct cells: [], x_cell_count: 0, y_cell_count: 0

  @type board :: %__MODULE__{ cells: [map] }

  @spec create_new(integer, integer) :: board
  def create_new(x, y) do
    %__MODULE__{
      cells: generate_board_cells(x, y),
      x_cell_count: x,
      y_cell_count: y
    }
  end

  def cells_by_row(cells) do
    cells
    |> Enum.reduce(%{}, fn c, acc ->
      {_, updated} = Map.get_and_update(acc, c.y, fn row ->
        updated_row = if row, do: [c | row], else: [c]
        {row, updated_row}
      end)

      updated
    end)
    |> Enum.into([])
  end

  def cells_by_row_unfolded(row_cells) do
    row_cells
    |> Enum.into(%{})
    |> Enum.reduce([], fn {row, cells}, acc -> acc ++ cells end)
  end

  @spec generate_board_cells(integer, integer) :: [map]
  defp generate_board_cells(x_max, y_max) do
    for x <- 0..x_max,
        y <- 0..y_max,
        do: %{x: x, y: y, color: :white}
  end

#  Enum.sort_by(ac, &Map.fetch(&1, :y)) |> Enum.chunk_every(4)
end