import Foundation

public enum USBPacketError: Error {

    case invalidSync
    case invalidHeader
    case invalidPayload
    case invalidCRC
    case unexpectedEOF

}