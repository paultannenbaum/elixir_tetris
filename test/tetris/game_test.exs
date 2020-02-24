defmodule Tetris.GameTest do
  use Tetris.DataCase

  alias Tetris.Game

  describe "Game" do
    test "creating a new game" do
      expected = %Tetris.Board{
        board_status: 'open',
        cells: [%{color: :white, x: 0, y: 0}, %{color: :white, x: 0, y: 1}, %{color: :white, x: 0, y: 2}, %{color: :white, x: 0, y: 3}, %{color: :white, x: 1, y: 0}, %{color: :white, x: 1, y: 1}, %{color: :white, x: 1, y: 2}, %{color: :white, x: 1, y: 3}, %{color: :white, x: 2, y: 0}, %{color: :white, x: 2, y: 1}, %{color: :white, x: 2, y: 2}, %{color: :white, x: 2, y: 3}],
        score: 0
      }

      assert Game.new_board(2, 3) == expected
    end
  end
end
