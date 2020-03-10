defmodule Tetris.Game.Piece do
  @moduledoc """
  Provides all logic around creating and manipulating a tetris game piece (also known as a tetrominoe)
  """

  @enforce_keys [:coords, :color, :type, :point_grid_length]
  defstruct type: :i,
            color: :blue,
            point_grid_length: 3,
            coords: []

  @type piece :: %__MODULE__{
               type: atom,
               color: atom,
               point_grid_length: integer,
               coords: [coord]
             }
  @type coord :: %{x: integer, y: integer, p: [point]}
  @type point :: {integer, integer}

  @piece_types [
    %{type: :i, color: :blue, point_grid_length: 4},
    %{type: :t, color: :purple, point_grid_length: 3},
    %{type: :z, color: :green, point_grid_length: 3},
    %{type: :l, color: :red, point_grid_length: 3},
    %{type: :o, color: :orange, point_grid_length: 3}]

  @spec create_new(integer, integer) :: piece
  def create_new(x_max, y_max), do: create_new(x_max, y_max, Enum.random(@piece_types))

  @spec create_new(integer, integer, atom) :: piece
  def create_new(x_max, y_max, t) do
    %__MODULE__{
      type: t.type,
      color: t.color,
      point_grid_length: t.point_grid_length,
      coords: initial_coords(x_max, y_max, t.type)
    }
  end

  @spec down(piece) :: piece
  def down(piece) do
    %{piece | coords: Enum.map(piece.coords, fn c ->
      %{c | y: c.y - 1 }
    end)}
  end

  @spec left(piece) :: piece
  def left(piece) do
    %{piece | coords: Enum.map(piece.coords, fn c ->
      %{c | x: c.x - 1 }
    end)}
  end

  @spec right(piece) :: piece
  def right(piece) do
    %{piece | coords: Enum.map(piece.coords, fn c ->
      %{c | x: c.x + 1 }
    end)}
  end

  @spec rotate_clockwise(piece) :: piece
  def rotate_clockwise(piece) do
    piece |> reflect_piece |> transpose_piece
  end

  @spec rotate_counter_clockwise(piece) :: piece
  def rotate_counter_clockwise(piece) do
    piece |> mirror_piece |> transpose_piece
  end

  @spec mirror_piece(piece) :: piece
  defp mirror_piece(piece) do
    new_points = get_points(piece) |> Enum.map(&(mirror_point(&1, piece.point_grid_length)))

    piece
    |> update_piece_from_new_points(new_points)
  end

  @spec reflect_piece(piece) :: piece
  defp reflect_piece(piece) do
    new_points = get_points(piece) |> Enum.map(&(reflect_point(&1, piece.point_grid_length)))

    piece
    |> update_piece_from_new_points(new_points)
  end

  @spec transpose_piece(piece) :: piece
  defp transpose_piece(piece) do
    new_points = get_points(piece) |> Enum.map(&transpose_point/1)

    piece
    |> update_piece_from_new_points(new_points)
  end

  @spec get_points(piece) :: [point]
  defp get_points(piece), do: Enum.map(piece.coords, fn c -> c.p end)

  @spec mirror_point(point, integer) :: point
  def mirror_point({px, py}, point_grid_length), do: {point_grid_length - px, py}

  @spec reflect_point(point, integer) :: point
  def reflect_point({px, py}, point_grid_length), do: {px, point_grid_length - py}

  @spec transpose_point(point) :: tuple
  def transpose_point({px, py}), do: {py, px}

  @spec initial_coords(integer, integer, atom) :: [coord]
  defp initial_coords(x_max, y_max, type) do
    start_x = (floor(x_max/2) - 2) + 1
    start_y = y_max + 1

    shape_points = case type do
      :i -> [{2,1},{2,2},{2,3},{2,4}]
      :t -> [{1,1},{2,1},{3,1},{2,2}]
      :z -> [{1,2},{2,2},{2,1},{3,1}]
      :l -> [{1,1},{1,2},{1,3},{2,1}]
      :o -> [{1,1},{1,2},{2,1},{2,2}]
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

  @spec update_piece_from_new_points(piece, [point]) :: piece
  defp update_piece_from_new_points(piece, points) do
    updated_coords = Enum.zip(piece.coords, points)
    |> Enum.map(fn {c, p} ->
       {p1x, p1y} = c.p
       {p2x, p2y} = p
        Map.merge(c, %{
          x: c.x + p2x - p1x,
          y: c.y - p2y + p1y,
          p: p
        })
    end)

    %{piece | coords: updated_coords}
  end
end