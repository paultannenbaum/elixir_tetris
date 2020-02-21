# Elixir Tetris

The goal of this project is to build a basic implementation of the game Tetris, in order to learn elixir/phoenix and phoenix liveview.

This will be a basic version of the game, without some of the more advanced game play features.

Feature List:
- Different color pieces
- Rotatable pieces
- Movable pieces
- A line across the screen will be removed and add points to user
- When pieces reach top of board, game is over
- The entire game loop will happen in live view
- Try and do as much via TDD as possible

Most likely will not be included:
- Piece speedup as user progresses
- State saved to DB

Milestones:

1) [x] Render Board to DOM

2) [ ] Render Piece inside of Board/ Piece falls down the board

3) [ ] Piece logic: movable and rotatable by user

4) [ ] Board Logic: allowing pieces to fit, removing lines, etc. 

# Running the game

To start your Phoenix server:
* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Install Node.js dependencies with `cd assets && npm install`
* Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.