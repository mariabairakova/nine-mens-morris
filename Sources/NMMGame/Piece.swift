
public class Piece {
    var color: PieceColor 

    var pieceColor: String {
        get { color.rawValue }
    }

    public init(color: PieceColor) {
        self.color = color
    }  
}


