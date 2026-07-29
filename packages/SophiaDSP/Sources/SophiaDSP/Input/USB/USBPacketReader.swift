import Foundation

public final class USBPacketReader {

    private let transport: Transport

    public init(
        transport: Transport
    ) {
        self.transport = transport
    }

    public func nextPacket() throws -> Data {

        return try transport.read(
            maxLength: 4096
        )
    }
}