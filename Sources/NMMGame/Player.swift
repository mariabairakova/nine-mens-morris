let possibleMills = [
    //horizontal
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [9, 10, 11],
    [12, 13, 14], 
    [15, 16, 17],
    [18, 19, 20],
    [21, 22, 23],

    //vertical 
    [0, 9, 21],
    [3, 10, 18],
    [6, 11, 15],
    [1, 4, 7], 
    [16, 19, 22],
    [8, 12, 17],
    [5, 13, 20],
    [2, 14, 23],
]

let possibleMoves = [
    [1, 9], //A1 
    [0, 2, 4], //D1
    [1, 14], //G1
    [4, 10], //B2
    [1, 7, 3, 5], //D2
    [4, 13], //F2
    [7, 11], //C3
    [4, 6, 8], //D3
    [7, 12], //E3
    [0, 21, 10], //A4
    [3, 18, 9, 11], //B4
    [6, 15, 10], //C4
    [8, 17, 13], //E4
    [5, 20, 12, 14], //F4
    [2, 23, 13], //G4
    [11, 16], //C5
    [15, 17, 19], //D5
    [12, 16], //E5
    [10, 19], //B6
    [16, 18, 20, 22], //D6
    [13, 19], //F6
    [9, 22], //A7
    [19, 21, 23], //D7
    [14, 22], //G7
]

let piecesToPlay = 9

class Player {
    
    var name: String 
    var color: PieceColor
    var piecesLeftToPlace: Int = piecesToPlay
    var piecesCount: Int = piecesToPlay //number of pieces on board left to play
    var piecesOnBoard: [Int] = [] //list of current pieces' on board IDs
    var mills: [[Int]] = [] //list of current mills
    
    var canFly: Bool {
        get {
            return piecesCount == 3
        }
    }

    //property is false when all player's pieces on board are part of mills
    var hasPiecesNotInMill: Bool {
        get {
            for p in piecesOnBoard {
                if !isInMill(piece: p) {
                    return true
                }
            }
            return false
        }
    }

    init(name: String, color: PieceColor) {
        self.name = name
        self.color = color
    }

    //adding piece to list of current pieces on board, returns true if added piece forms a mill 
    func placePiece(on position: String, pieces: inout [Piece]) throws -> Bool {

        var canTakePiece = false

        if let pos = ValidPosition(rawValue: position) {

            let id = pos.getPositionID() 

            if pieces[id].color == .none {
                pieces[id] = Piece(color: color)
                piecesOnBoard.append(id)
        
                if formedMills() {
                    canTakePiece = true
                }

                piecesLeftToPlace -= 1
            } 
            else {
                throw PositionError.occupiedPosition
            } 
        } 
        else {
            throw PositionError.invalidPosition
        }

        return canTakePiece
    }

    //checks whether player pieces are blocked
    func canMove(pieces: [Piece]) -> Bool {

        var pieceID: Int
        var neighbourID: Int

        if canFly { 
            return true 
        }
        
        //checking the color of all neighbour pieces of player's placed pieces
        for i in 0..<piecesOnBoard.count {
            pieceID = piecesOnBoard[i]
            for j in 0..<possibleMoves[pieceID].count {
                neighbourID = possibleMoves[pieceID][j]
                if pieces[neighbourID].color == .none {
                    return true
                }
           }
        }
        return false
    }

    //selecting piece from other player to be removed from pieces list
    func takePiece(from opponent: Player, pieces: inout [Piece]) {

        var inputError = true
        print("\(name) selects piece to take from opponent:")

        repeat {
            if let position = readLine() {
                do {
                    try opponent.removeFromBoard(at: position, pieces: &pieces)  
                    inputError = false
                } 
                catch let error as PositionError {
                    print(error.rawValue)  
                }
                catch {
                    print("\(error)")
                }
            }
        } while inputError
        
    }

    //getting coordinates to move a piece
    func move(pieces: inout [Piece]) -> Bool {

        var inputError = true
        var canTakePiece = false

        print("\(name) selects piece to move:")

        repeat {
            if let coordinates = readLine() { 
                if !coordinates.isEmpty && coordinates.count == 4  {
                    
                    let firstPosition = String(coordinates[coordinates.startIndex...coordinates.index(after: coordinates.startIndex)])
                    let secondPosition = String(coordinates[coordinates.index(coordinates.startIndex, offsetBy: 2)..<coordinates.endIndex])
                
                    do {
                        try canTakePiece = movePiece(from: firstPosition, to: secondPosition, pieces: &pieces)  
                        inputError = false
                    } 
                    catch let error as PositionError {
                        print(error.rawValue)  
                    }
                    catch {
                        print("\(error)")
                    }
                }
                else {
                    print("Invalid coordinates! Please, enter again:")       
                }
            } 
        } while inputError

        return canTakePiece
    }
}

//private functions
extension Player {

    //deleting piece from list of current pieces on board
    private func removeFromBoard(at position: String, pieces: inout [Piece]) throws {

        if let pos = ValidPosition(rawValue: position) {

            let id = pos.getPositionID()

            if isInMill(piece: id) && hasPiecesNotInMill {
                throw PositionError.millPosition
            } else if pieces[id].color == color {

                if isInMill(piece: id) {
                    removeMill(piece: id)
                }

                piecesCount -= 1
                piecesOnBoard = piecesOnBoard.filter{ $0 != id }
                pieces[id] = Piece(color: .none)
            }
            else {
                throw PositionError.invalidPosition
            } 
        } 
        else {
            throw PositionError.invalidPosition
        }
    }

      //moving player's piece, returns true if moved piece forms mill
    private func movePiece(from: String, to: String, pieces: inout [Piece]) throws -> Bool {

        var canTakePiece = false

        if let firstPosition = ValidPosition(rawValue: from), let secondPosition = ValidPosition(rawValue: to) {
           
            let fromID = firstPosition.getPositionID() 
            let toID = secondPosition.getPositionID() 

            if pieces[fromID].color == color && pieces[toID].color == .none {

                if !canFly && !possibleMoves[fromID].contains(toID) {
                    throw PositionError.invalidMove
                }   

                if canFly || ( !canFly && possibleMoves[fromID].contains(toID) ) {
                
                    if isInMill(piece: fromID) {
                        removeMill(piece: fromID)
                    }

                    piecesOnBoard.append(toID)
                    piecesOnBoard = piecesOnBoard.filter{ $0 != fromID }

                    pieces[fromID] = Piece(color: .none)
                    pieces[toID] = Piece(color: color)
                    
                    if formedMills() {
                        canTakePiece = true
                    }
                } 
            }               
            else {
                throw PositionError.invalidCoordinates
            }
        } else {
            throw PositionError.invalidCoordinates
        }
        return canTakePiece
    }

    //checking by ID if piece is part of player's mill list
    private func isInMill(piece: Int) -> Bool {
        for i in 0..<mills.count {
            for j in 0..<mills[0].count {
                if piece == mills[i][j] {
                    return true
                }
            }
        }
        return false
    }

    //removing mill from player's mill list by piece ID
    private func removeMill(piece: Int) {
        var index = 0
        for i in 0..<mills.count {
            for j in 0..<mills[0].count {
                if piece == mills[i][j] {
                    index = i
                }
            }
        }
        mills.remove(at: index)
    }

    //adding mill to list of player's mills, returns true if mill is added
    private func formedMills() -> Bool {
        
        piecesOnBoard.sort()

        for i in 0..<piecesOnBoard.count {
            for j in 0..<possibleMills.count {
                if piecesOnBoard[i] == possibleMills[j].first {
                    if piecesOnBoard.contains(possibleMills[j][1]) && piecesOnBoard.contains(possibleMills[j][2]) {
                        if !mills.contains(possibleMills[j]) {
                            mills.append(possibleMills[j])
                            return true
                        }
                    }
                } 
            }
        }
        return false
    }
    
}

