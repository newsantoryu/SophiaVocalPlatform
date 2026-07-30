import Foundation

public enum TransportError: Error {

    case portNotFound

    case openFailed

    case disconnected

    case timeout

    case invalidPacket

    case readFailed

    case writeFailed

    case invalidSync
}