defmodule Tetris.GameTest do
  use Tetris.DataCase

  alias Tetris.Game
  alias Tetris.Game.Board
  alias Tetris.Game.Piece

  describe "Game" do
    test "creating a new game" do
      expected = %Board{
        board_status: 'open',
        cells: [%{color: :white, x: 0, y: 0}, %{color: :white, x: 0, y: 1}, %{color: :white, x: 0, y: 2}, %{color: :white, x: 0, y: 3}, %{color: :white, x: 1, y: 0}, %{color: :white, x: 1, y: 1}, %{color: :white, x: 1, y: 2}, %{color: :white, x: 1, y: 3}, %{color: :white, x: 2, y: 0}, %{color: :white, x: 2, y: 1}, %{color: :white, x: 2, y: 2}, %{color: :white, x: 2, y: 3}],
        score: 0
      }

      assert Game.new_board(2, 3) == expected
    end

    test "creating a new piece" do
      new_piece = Game.new_piece()

      assert Enum.member?([:i, :t, :z, :l], new_piece.type)
      assert %Piece{} = new_piece
    end

    test "moving a piece down" do
      new_piece = Game.new_piece()


    end
  end
end
