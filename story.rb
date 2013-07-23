#Story
#Player 1 chooses what piece to move (by its position)
#Player 1 chooses where to move that piece (by position)
#Board checks if there is a piece at initial position. If no, then ask the player to try again.
#                                                      If yes, then see if the move is valid.
#For a move to be valid, the piece must be able to make such a move,
#                        there must be no piece in the way (Exception: Knight)
#                        there must not be a piece of same color on final position
#                        the king must not be in check.
#           [Be wary of Pawn]
#If enemy piece on final position, store enemy piece in killed battlemen and remove from board. Then, move piece.
#Otherwise, just move piece.
#Check if won game, or if enemy king is in check.
#If game not won, Player 2 moves and repeats (2 - 13).