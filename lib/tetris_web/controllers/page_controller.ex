defmodule TetrisWeb.PageController do
  use TetrisWeb, :controller

  alias Tetris.Board

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def game(conn, _params) do
    board = Board.new_board()
    render(conn, "game.html", board: board)
  end
end
