import Foundation

public struct USBPacketHeader: Equatable, Sendable {

    public static let sync0: UInt8 = 0xAA
    public static let sync1: UInt8 = 0x55

    public let payloadSize: UInt16
    public let crc: UInt16

    public init(payloadSize: UInt16, crc: UInt16) {
        self.payloadSize = payloadSize
        self.crc = crc
    }
}