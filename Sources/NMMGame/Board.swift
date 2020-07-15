
class Board {
    
    var pieces: [Piece]

    var currentBoard: [Piece] {
        get { pieces }
    }

    init(pieces: [Piece]) {
        self.pieces = pieces
    }
    
    func printBoard() {
        print("    A   B   C   D   E   F   G")
        print("1   \(pieces[0].pieceColor)-----------\(pieces[1].pieceColor)-----------\(pieces[2].pieceColor)")
        print("    |           |           |")
        print("2   |   \(pieces[3].pieceColor)-------\(pieces[4].pieceColor)-------\(pieces[5].pieceColor)   |")
        print("    |   |       |       |   |")
        print("3   |   |   \(pieces[6].pieceColor)---\(pieces[7].pieceColor)---\(pieces[8].pieceColor)   |   |")
        print("    |   |   |       |   |   |")
        print("4   \(pieces[9].pieceColor)---\(pieces[10].pieceColor)---\(pieces[11].pieceColor)       \(pieces[12].pieceColor)---\(pieces[13].pieceColor)---\(pieces[14].pieceColor)")
        print("    |   |   |       |   |   |")
        print("5   |   |   \(pieces[15].pieceColor)---\(pieces[16].pieceColor)---\(pieces[17].pieceColor)   |   |")
        print("    |   |       |       |   |")
        print("6   |   \(pieces[18].pieceColor)-------\(pieces[19].pieceColor)-------\(pieces[20].pieceColor)   |")
        print("    |           |           |")
        print("7   \(pieces[21].pieceColor)-----------\(pieces[22].pieceColor)-----------\(pieces[23].pieceColor)")
    }

    func emptyBoard()  {
        var pieces: [Piece] = []
        for _ in 0...23 {
            pieces.append(Piece(color: PieceColor.none))
        }
        self.pieces = pieces
    }   
}

