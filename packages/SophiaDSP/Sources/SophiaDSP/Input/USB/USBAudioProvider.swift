import Foundation

public final class USBAudioProvider: AudioBufferProvider {

    // MARK: - Properties

    private let transport: Transport
    private let format: PCMFormat

    private let packetReader: USBPacketReader
    private let decoder: PCM16Decoder

    private var isRunning = false

    // MARK: - Init

    public init(
        transport: Transport,
        format: PCMFormat
    ) {

        self.transport = transport
        self.format = format

        self.packetReader = USBPacketReader(
            transport: transport
        )

        self.decoder = PCM16Decoder(
            format: format
        )
    }

    // MARK: - AudioBufferProvider

    public func start(
        onBuffer: @escaping ([Float]) -> Void
    ) throws {

        try transport.open()

        defer {
            transport.close()
        }

        isRunning = true

        while isRunning {

             let packet = try packetReader.nextPacket()

            guard !packet.isEmpty else {
                continue
            }

            let samples = try decoder.decode(packet)

            guard !samples.isEmpty else {
                continue
            }

            onBuffer(samples)
        }
    }

    public func stop() {

        isRunning = false

    }
}