
var p1 = Player(name: "Player 1", color: PieceColor.black)
var p2 = Player(name: "Player 2", color: PieceColor.white)
var board = Board(pieces: [])

let game = Game(player1: p1, player2: p2, board: board)

game.run()



