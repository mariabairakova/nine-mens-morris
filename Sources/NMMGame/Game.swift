

class Game {

    var player1: Player
    var player2: Player
    var board: Board

    init(player1: Player, player2: Player, board: Board) {
        self.player1 = player1
        self.player2 = player2
        self.board = board
    }

    func run() {

        enterPlayerNames()
 
        print("Starting the game...")
        board.emptyBoard()
        board.printBoard()

        print("Placing all pieces on the board...")
        placingPieces()

        print("Moving pieces...")
        movingPieces()
        
        print("End of the game!")   
    }
}

//private functions
extension Game {

    //phase 1 of the game, players take turns placing all of their pieces
    private func placingPieces() {

        var currentPlayer = player1
        var opponent  = player2

        while player2.piecesLeftToPlace > 0 { 
            do {
                try placeOnBoard(player1: currentPlayer, player2: opponent) 
                changePlayer(currentPlayer: &currentPlayer, opponent: &opponent)
            } catch let error as PositionError {
                print(error.rawValue)
            } catch {
                print("\(error)")
            }
        }
    }

    //player selects position to place a piece and takes piece from other player if a mill is formed
    private func placeOnBoard(player1 p1: Player, player2 p2: Player) throws {

        var canTakePiece = false
        var pieces = board.currentBoard

        print("\(p1.name) places piece:")

        if let position = readLine() {
          do {
            try canTakePiece = p1.placePiece(on: position, pieces: &pieces)
            showUpdatedBoard(with: pieces)

            if canTakePiece {
                p1.takePiece(from: p2, pieces: &pieces)
                showUpdatedBoard(with: pieces)
            }  
          } 
          catch let error as PositionError {
            throw error
          }
          catch {
            print("\(error)")
          }
         
        }
    }

    //phase 2, players continue to alternate moves, moving a piece to an adjacent position
    private func movingPieces() {

        var currentPlayer = player1
        var opponent  = player2
        var pieces = board.currentBoard
        var canTakePiece = false
        var winner: String? = nil

        while winner == nil {
            canTakePiece = currentPlayer.move(pieces: &pieces)
            showUpdatedBoard(with: pieces)

             if canTakePiece {
                currentPlayer.takePiece(from: opponent, pieces: &pieces)
                showUpdatedBoard(with: pieces)
            }

            changePlayer(currentPlayer: &currentPlayer, opponent: &opponent)
            pieces = board.currentBoard
    
            winner = checkForWinner(player1: currentPlayer, player2: opponent, pieces: pieces)
        }

        if winner! != "Draw!" {
            print("The winner is \(winner!)!") 
        } else {
            print(winner!)
        }
    }

    //checking all conditions for end of the game
    private func checkForWinner(player1: Player, player2: Player, pieces: [Piece]) -> String? {
        if player1.piecesCount == 2 || !player1.canMove(pieces: pieces) {
            return player2.name
        }

        if player2.piecesCount == 2 || !player2.canMove(pieces: pieces) {
            return player1.name
        }

        if player1.piecesCount == 3 && player2.piecesCount == 3 {
            return "Draw!"
        }

        return nil
    }

    private func enterPlayerNames() {

        print("Player 1's name:")
        if let p1 = readLine() {
            if !p1.isEmpty {
                player1 = Player(name: p1, color: PieceColor.black) 
            }
        }
          
        var identicalName = true
        repeat {
        print("Player 2's name:")
            if let p2 = readLine() {
                if p2 == player1.name {
                    print("Please choose another name, different from Player 1's name.")
                } else if !p2.isEmpty {
                    player2 = Player(name: p2, color: PieceColor.white)
                    identicalName = false
                } else {
                    identicalName = false
                }
            }
        } while identicalName
    }

    private func changePlayer(currentPlayer: inout Player, opponent: inout Player) {
        if currentPlayer.name == player1.name {
            opponent = player1
            currentPlayer = player2
        } 
        else {
            opponent = player2
            currentPlayer = player1
        }
    }

    private func showUpdatedBoard(with pieces: [Piece]) {
        board = Board(pieces: pieces)
        board.printBoard()
    }   

}


