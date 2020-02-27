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
  def create_new(x_max, y_max, t), do: %__MODULE__{
    type: t.type,
    color: t.color,
    coords: initial_coords(x_max, y_max, t.type)
  }

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

  def rotate_clockwise(piece) do
    max_x = Enum.map(piece.coords, fn x -> x.x end) |> Enum.max
    max_y = Enum.map(piece.coords, fn x -> x.y end) |> Enum.max

    %{piece | coords: Enum.map(piece.coords, fn c ->
      %{x: (c.y + max_x - max_y), y: (c.x + max_y - max_x )}
    end)}
  end


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
    max_x = Enum.map(piece.coords, fn x -> x.x end) |> Enum.max
    max_y = Enum.map(piece.coords, fn x -> x.y end) |> Enum.max

    %{piece | coords: Enum.map(piece.coords, fn c -> %{x: c.y, y: c.x} end)}
  end

  @spec initial_coords(integer, integer, atom) :: [map]
  defp initial_coords(x_max, y_max, type) do
    starting_y_coord = y_max
    starting_x_coord = floor(x_max/2) - 2

    case type do
      :i ->
        [
          %{x: starting_x_coord + 2, y: starting_y_coord - 0},
          %{x: starting_x_coord + 2, y: starting_y_coord - 1},
          %{x: starting_x_coord + 2, y: starting_y_coord - 2},
          %{x: starting_x_coord + 2, y: starting_y_coord - 3}
        ]
      :t ->
        [
          %{x: starting_x_coord + 2, y: starting_y_coord - 0},
          %{x: starting_x_coord + 1, y: starting_y_coord - 1},
          %{x: starting_x_coord + 2, y: starting_y_coord - 1},
          %{x: starting_x_coord + 3, y: starting_y_coord - 1},
        ]
      :z ->
        [
          %{x: starting_x_coord + 1, y: starting_y_coord - 0},
          %{x: starting_x_coord + 2, y: starting_y_coord - 0},
          %{x: starting_x_coord + 2, y: starting_y_coord - 1},
          %{x: starting_x_coord + 3, y: starting_y_coord - 1},
        ]
      :l ->
        [
          %{x: starting_x_coord + 2, y: starting_y_coord - 0},
          %{x: starting_x_coord + 2, y: starting_y_coord - 1},
          %{x: starting_x_coord + 2, y: starting_y_coord - 2},
          %{x: starting_x_coord + 3, y: starting_y_coord - 2},
        ]
    end
  end
end