defmodule TetrisWeb.PageController do
  use TetrisWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
