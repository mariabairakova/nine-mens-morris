public enum PieceColor: String {
    case none = "."
    case white = "○"
    case black = "●"
}

enum ValidPosition: String, CaseIterable {
    case A1
    case D1
    case G1
    case B2
    case D2
    case F2
    case C3
    case D3
    case E3
    case A4
    case B4
    case C4
    case E4
    case F4
    case G4
    case C5
    case D5
    case E5
    case B6
    case D6
    case F6
    case A7
    case D7
    case G7

    func getPositionID() -> Int {
        var i = 0
        for position in ValidPosition.allCases {
            if position == self {
                return i
            }
            i+=1
        }
        return -1
    }
}