import Foundation

public final class USBAudioProvider: AudioBufferProvider {

    // MARK: - Properties

    private let transport: Transport

    private let packetReader: USBPacketReader

    private var isRunning = false

    private let decoder = PCM16Decoder()

    // MARK: - Init

    public init(
        transport: Transport
    ) {

        self.transport = transport

        self.packetReader = USBPacketReader(
            transport: transport
        )

    }

    // MARK: - AudioBufferProvider

    public func start(
        onBuffer: @escaping ([Float]) -> Void
    ) throws {

        try transport.open()

        isRunning = true

        defer {
            transport.close()
        }

        while isRunning {

            let packet = try packetReader.nextPacket()

            guard !packet.isEmpty else {
                continue
            }

            let samples = try decoder.decode(
                data: packet
            )

            guard !samples.isEmpty else {
                continue
            }

            onBuffer(samples)
        }
    }

    public func stop() {

        isRunning = false

        transport.close()

    }

}