enum PositionError: String, Error {
    case invalidPosition = "The position is invalid! Please, enter new position:"
    case occupiedPosition = "The position is already occupied! Please, enter new position:"
    case millPosition = "Can't take piece from mill! There are other pieces to take. Please, enter new position:"
    case invalidCoordinates = "The coordinates are invalid! Please, enter again: "
    case invalidMove = "You can't move to this position. Please, enter new position:"
}