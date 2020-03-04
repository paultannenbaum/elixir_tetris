defmodule Tetris.Game.Board do
  defstruct rows: [], x_cell_count: 0, y_cell_count: 0, cell_color: :white

  @type board :: %__MODULE__{ rows: [tuple], x_cell_count: integer, y_cell_count: integer }

  @spec create_new(integer, integer) :: board
  def create_new(x, y) do
    %__MODULE__{
      x_cell_count: x,
      y_cell_count: y
    } |> generate_rows
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

  @spec generate_rows(board) :: board
  defp generate_rows(board) do
    rows = for y <- 0..board.y_cell_count do
      cells = for x <- 0..board.x_cell_count, do: %{x: x, y: y, color: board.cell_color}
      {y, cells}
    end
    %{board | rows: rows}
  end

#  Enum.sort_by(ac, &Map.fetch(&1, :y)) |> Enum.chunk_every(4)
end