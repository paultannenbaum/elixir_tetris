defmodule Tetris.Game.Piece do
  defstruct type: :i,
            color: :blue,
            coords: []

  @type piece :: %__MODULE__{
               type: atom,
               color: atom,
               coords: [map]
             }

  @piece_types [
    %{type: :i, color: :blue},
    %{type: :t, color: :yellow},
    %{type: :z, color: :green},
    %{type: :l, color: :red}]

  @spec create_new(integer, integer) :: piece
  def create_new(x_max, y_max), do: create_new(x_max, y_max, Enum.random(@piece_types))

  @spec create_new(integer, integer, atom) :: piece
  def create_new(x_max, y_max, t) do
    %__MODULE__{
      type: t.type,
      color: t.color,
      coords: initial_coords(x_max, y_max, t.type),
    }
  end



  @spec down(piece) :: piece
  def down(piece) do
    %{piece | coords: Enum.map(piece.coords, fn c -> %{x: c.x, y: c.y - 1} end)}
  end

  @spec left(piece) :: [piece]
  def left(piece) do
    %{piece | coords: Enum.map(piece.coords, fn c -> %{x: c.x - 1, y: c.y} end)}
  end

  def right(piece) do
    %{piece | coords: Enum.map(piece.coords, fn c -> %{x: c.x + 1, y: c.y} end)}
  end

#  def rotate_clockwise(piece) do
#
#  end


#  def rotate_counter_clockwise(piece) do
#
#  end

  defp mirror_piece_x_axis(piece) do
    %{piece | coords: Enum.map(piece.coords, fn c -> %{x: 3 - c.x, y: c.y} end)}
  end

  def mirror_piece_y_axis(piece) do
    %{piece | coords: Enum.map(piece.coords, fn c -> %{x: c.x, y: 3 - c.y} end)}
  end

  def inverse(piece) do
    %{piece | coords: Enum.map(piece.coords, fn c -> %{x: c.y, y: c.x} end)}
  end

  @spec initial_coords(integer, integer, atom) :: [map]
  defp initial_coords(x_max, y_max, type) do
    start_x = floor(x_max/2) - 2
    start_y = y_max

    shape_points = case type do
      :i -> [{2,0},{2,1},{2,2},{2,3}]
      :t -> [{2,0},{1,1},{2,1},{3,1}]
      :z -> [{1,0},{2,0},{2,1},{3,1}]
      :l -> [{2,0},{2,1},{2,2},{3,2}]
    end

    shape_points
    |> Enum.map(fn {x, y} ->
      %{
        x: start_x + x,
        y: start_y - y,
        p: {x,y}
      }
    end)
  end
end