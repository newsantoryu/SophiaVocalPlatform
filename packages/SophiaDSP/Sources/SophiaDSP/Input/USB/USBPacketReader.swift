import Foundation

public final class USBPacketReader {

    // MARK: - Properties

    private let transport: Transport

    // MARK: - Init

    public init(
        transport: Transport
    ) {

        self.transport = transport

    }

    // MARK: - Public

    public func nextPacket() throws -> Data {

        try transport.read(
            maxLength: 4096
        )

    }

}