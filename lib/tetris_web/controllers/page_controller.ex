defmodule TetrisWeb.PageController do
  use TetrisWeb, :controller

  alias Tetris.Game

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def game(conn, _params) do
    board = Game.new_board()
            |> Game.update_board_coord(%{x: 1, y: 60}, "yellow")

    render(conn, "game.html", board: board)
  end
end
