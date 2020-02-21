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

1) Render Board to DOM

2) Render Piece inside of Board

3) Piece falls down the board

4) Piece is movable and rotatable by user

5) Piece stacks when hitting bottom

6) Render logic: allowing pieces to fit, removing lines, etc.