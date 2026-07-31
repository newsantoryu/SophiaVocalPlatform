import Foundation

public enum SATPError: Error {

    case invalidSync
    case invalidHeader
    case invalidPayload
    case invalidCRC
    case unexpectedEOF

}