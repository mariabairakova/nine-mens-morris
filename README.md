# NMMGame

Basic implementation of nine men's morris board game using Swift Package Manager. 

At the beginning players are asked to choose a name to be used in the game. If no name is specified, default names are provided (Player 1, Player 2). Fisrt user plays with black pieces, secod user plays with white pieces (colores are inversed in black terminal).

Players can place piece by entering coordinates of the position they want (e.g. A1).

Empty positions are marked with "." , occupied positions are marked with "○" or "●". 

Players can move piece by entering two coordinates: first is the position their piece is located and other is the postition where the piece will be moved. (e.g. A1D1).

When a mill is formed player is asked to enter a position of opponent's piece to be removed from 
board. 

Board with current pieces on it is displayed on every turn.

