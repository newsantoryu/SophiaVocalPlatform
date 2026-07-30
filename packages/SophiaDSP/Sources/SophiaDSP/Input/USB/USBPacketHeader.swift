import Foundation

public struct USBPacketHeader: Equatable, Sendable {

    // MARK: - Constants

    public static let sync0: UInt8 = 0xAA
    public static let sync1: UInt8 = 0x55

    // MARK: - Header

    public let sequence: UInt32

    public let timestamp: UInt64

    public let payloadSize: UInt16

    public let crc: UInt16

    public init(
        sequence: UInt32,
        timestamp: UInt64,
        payloadSize: UInt16,
        crc: UInt16
    ) {
        self.sequence = sequence
        self.timestamp = timestamp
        self.payloadSize = payloadSize
        self.crc = crc
    }
}