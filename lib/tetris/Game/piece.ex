defmodule Tetris.Piece do
  defstruct type: :i, rotation: 0, color: 'blue', coords: []

  @types [:i, :t, :z, :l]

  def create_new(), do: create_new(Enum.random(@types))
  def create_new(:i), do: %Tetris.Piece{type: :i, color: 'blue'}
  def create_new(:t), do: %Tetris.Piece{type: :i, color: 'yellow'}
  def create_new(:z), do: %Tetris.Piece{type: :i, color: 'green'}
  def create_new(:l), do: %Tetris.Piece{type: :i, color: 'red'}

  def down(piece) do

  end

  def left(piece) do

  end

  def right(piece) do

  end

  def rotate_clockwise(piece) do

  end

  def rotate_counter_clockwise(piece) do

  end

  ## Private

  defp mirror_piece_x_axis do

  end

  def mirror_piece_y_axis do

  end

  def mirror_piece_x_y_axis do

  end
end