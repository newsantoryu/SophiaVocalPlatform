import Foundation

public struct USBPacket: Sendable {

    public let sequence: UInt32

    public let timestamp: UInt64

    public let payload: Data

    public init(
        sequence: UInt32,
        timestamp: UInt64,
        payload: Data
    ) {
        self.sequence = sequence
        self.timestamp = timestamp
        self.payload = payload
    }

}