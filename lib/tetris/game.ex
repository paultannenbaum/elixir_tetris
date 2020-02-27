defmodule Tetris.Game do
  @moduledoc """
    Game context holds all the business logic for game play. This includes board state management,
    piece movement, and scoring
  """

  defstruct board: nil,
            active_piece: nil,
            score: 0,
            status: :closed,
            speed: 400

  alias Tetris.Game.Board
  alias Tetris.Game.Piece

  @type game  :: %__MODULE__{}
  @type board :: %Board{}
  @type piece :: %Piece{}

  @x_cells 25
  @y_cells 30

  @spec new_game() :: game
  def new_game() do
    %__MODULE__{board: Board.create_new(@x_cells, @y_cells)}
  end

  @spec start_game(game) :: game
  def start_game(game) do
    g1 = Map.merge(game, %{
      active_piece: Piece.create_new(@x_cells, @y_cells),
      status: :open
    })
    {:ok, g2} = set_piece_on_board(g1)
    g2
  end

  # TODO: Handle failure state
  @spec move_piece(game, atom) :: game
  def move_piece(game, direction) do
    ## create new state
    {:ok, g1} = remove_piece_from_board(game)
    # dynamically call the correct piece movement function
    p1 = apply(Piece, direction, [game.active_piece])
    g2 = Map.merge(game, %{
      board: g1.board,
      active_piece: p1
    })

    ## validate state

    ## insert new state if valid
    {:ok, g3} = set_piece_on_board(g2)
    g3
  end

  # Private
  # TODO: Handle failure state
  @spec set_piece_on_board(game) :: atom
  defp set_piece_on_board(game) do
    %{board: b, active_piece: p} = game

    coords = Enum.map(p.coords, fn %{x: x, y: y} -> %{x: x, y: y} end)
    c1 = Enum.map(b.cells, fn c ->
      if (Enum.member?(coords, Map.take(c, [:x, :y]))) do
        %{c | color: p.color}
      else
        c
      end
    end)
    b1 = %{b | cells: c1}
    g1 = %{game | board: b1}

    {:ok, g1}
  end

  # TODO: Handle failure state
  @spec remove_piece_from_board(game) :: atom
  defp remove_piece_from_board(game) do
    %{board: b, active_piece: p} = game

    coords = Enum.map(p.coords, fn %{x: x, y: y} -> %{x: x, y: y} end)
    c1 = Enum.map(b.cells, fn c ->
      if (Enum.member?(coords, Map.take(c, [:x, :y]))) do
        %{c | color: :white}
      else
        c
      end
    end)
    b1 = %{b | cells: c1}
    g1 = %{game | board: b1}

    {:ok, g1}
  end
end
