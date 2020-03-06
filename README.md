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
- Try and do as much via TDD as possible ** update: Didn't happen, maybe backfill tests :(

Most likely will not be included:
- Piece speedup as user progresses
- State saved to DB

Milestones:

1) [x] Render Board to DOM

2) [x] Render Piece inside of Board/ Piece falls down the board

3) [x] Piece logic: movable and rotatable by user

4) [x] Board Logic: allowing pieces to fit, removing lines, etc. 

# Running the game

To start your Phoenix server:
* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Install Node.js dependencies with `cd assets && npm install`
* Start Phoenix endpoint with `mix phx.server`

Game should be playable at [`localhost:4000`](http://localhost:4000). To move the piece around the board, use the arrow keys, 
The `A` and `S` keyboard keys can be used to rotate the piece. There is still some additional work I need to do to get the rotation pieces
working exactly like the real game, and I think I am missing a couple pieces, but this is more of a proof of concept than anything else.