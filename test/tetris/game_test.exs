defmodule Tetris.GameTest do
  use Tetris.DataCase

  alias Tetris.Game
  alias Tetris.Game.Board
  alias Tetris.Game.Piece

  describe "Game" do
    test "creating a new game" do
      game = Game.new_game(2,2)

      assert %Game{}  = game
      assert %Board{} = game.board
    end

    test "starting a new game" do
      game = Game.new_game(2,2)

      assert game.status === :closed
      assert game.score === nil
      assert game.active_piece === nil

      game = Game.start_game(game)

      assert game.status === :open
      assert game.score === 0
      assert %Piece{} = game.active_piece
    end

    @tag :pending_test
    test "moving a piece" do
    end
  end
end
