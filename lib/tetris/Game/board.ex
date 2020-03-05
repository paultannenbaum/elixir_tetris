defmodule Tetris.Game.Board do
  defstruct rows: [], x_cell_count: 0, y_cell_count: 0, cell_color: :white

  @type board :: %__MODULE__{
                   rows: [row],
                   x_cell_count: integer,
                   y_cell_count: integer
                 }
  @type row :: {integer, [cell]}
  @type cell :: %{x: integer, y: integer, color: atom}

  @spec create_new(integer, integer) :: board
  def create_new(x, y) do
    %__MODULE__{
      x_cell_count: x,
      y_cell_count: y
    }
    |> create_rows
  end

  @spec update_cell(board, cell) :: board
  def update_cell(board, cell) do
    %{
      board |
      rows: Enum.map(
        board.rows,
        fn row = {y_index, cells} ->
          if y_index === cell.y do
            {y_index, Enum.map(cells, fn c -> if is_cell?(c, cell), do: cell, else: c end)}
          else
            row
          end
        end
      )
    }
  end

  @spec update_cells(board, [cell]) :: board
  def update_cells(board, []), do: board
  def update_cells(board, [cell | rest]), do: update_cells(update_cell(board, cell), rest)

  @spec get_cells(board) :: [cell]
  def get_cells(board) do
    Enum.reduce(board.rows, [], fn {_, cells}, acc -> acc ++ cells end)
  end

  @spec is_cell?(cell, cell) :: boolean
  def is_cell?(c1, c2) do
    c1.x === c2.x && c1.y === c2.y
  end

  @spec remove_scoring_row_and_adjust(board, integer) :: board
  def remove_scoring_row_and_adjust(board, row_index) do
    updated_rows = board.rows
                   |> Enum.reduce(
                        [],
                        fn (row = {i, cells}, acc) ->
                          cond do
                            i === row_index -> acc
                            i < row_index -> acc ++ [row]
                            i > row_index -> acc ++ [{i - 1, Enum.map(cells, fn c -> %{c | y: c.y - 1} end)}]
                          end
                        end
                      )

    %{board | rows: updated_rows}
    |> new_top_row
  end

  # Private
  @spec create_row(integer, integer, atom) :: row
  defp create_row(x, y, color) do
    {y, Enum.map(0..x, fn x -> %{x: x, y: y, color: color} end)}
  end

  @spec create_rows(board) :: board
  defp create_rows(board) do
    rows = for y <- 0..board.y_cell_count, do: create_row(board.x_cell_count, y, board.cell_color)
    %{board | rows: rows}
  end

  @spec new_top_row(board) :: board
  defp new_top_row(board) do
    new_top_row = create_row(board.x_cell_count, board.y_cell_count, board.cell_color)
    %{board | rows: board.rows ++ [new_top_row]}
  end
end