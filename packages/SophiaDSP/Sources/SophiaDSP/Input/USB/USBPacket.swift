import Foundation

public struct USBPacket: Sendable {

    public let header: USBPacketHeader

    public let payload: Data

    public init(
        header: USBPacketHeader,
        payload: Data
    ) {
        self.header = header
        self.payload = payload
    }
}