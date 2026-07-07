import Foundation

public final class WAVFileProvider: AudioBufferProvider {
    // MARK: - Properties

    private let data: Data
    public let header: WAVHeader

    private let audioDataOffset: Int
    private var currentOffset: Int

    private var isRunning = false

    private let bufferSize: Int

    // MARK: - Init

    public init(
        path: String,
        bufferSize: Int = 4096
    ) throws {

        self.data = try Data(contentsOf: URL(fileURLWithPath: path))
        self.header = try WAVFileProvider.parseHeader(from: data)

        self.audioDataOffset = 44
        self.currentOffset = audioDataOffset

        self.bufferSize = bufferSize

        try validate(header: header)
    }

    // MARK: - AudioBufferProvider

    public func start(
        onBuffer: @escaping ([Float]) -> Void
    ) throws {

        isRunning = true

        let bytesPerSample = 2

        while isRunning && currentOffset < data.count {

            let requestedBytes = bufferSize * bytesPerSample

            let availableBytes = min(
                requestedBytes,
                data.count - currentOffset
            )

            let sampleCount = availableBytes / bytesPerSample

            var samples: [Float] = []
            samples.reserveCapacity(sampleCount)

            for index in 0..<sampleCount {

                let offset = currentOffset + (index * bytesPerSample)

                let value: Int16 = data.withUnsafeBytes {
                    $0.load(
                        fromByteOffset: offset,
                        as: Int16.self
                    )
                }

                let normalized: Float

                if value == Int16.min {
                    normalized = -1.0
                } else {
                    normalized = Float(value) / Float(Int16.max)
                }

                samples.append(normalized)
            }

            currentOffset += sampleCount * bytesPerSample

            guard !samples.isEmpty else {
                continue
            }

            onBuffer(samples)
        }
    }

    public func stop() {
        isRunning = false
    }

    // MARK: - Validation

    private func validate(
        header: WAVHeader
    ) throws {

        guard header.chunkID == "RIFF" else {
            throw WAVError.invalidRIFFHeader
        }

        guard header.format == "WAVE" else {
            throw WAVError.invalidWAVEFormat
        }

        guard header.audioFormat == WAVFormat.pcm.rawValue else {
            throw WAVError.unsupportedAudioFormat
        }

        guard header.bitsPerSample == 16 else {
            throw WAVError.unsupportedBitDepth
        }

        guard header.numChannels == 1 else {
            throw WAVError.unsupportedChannelConfiguration
        }
    }
}

// MARK: - Parsing

extension WAVFileProvider {

    static func parseHeader(
        from data: Data
    ) throws -> WAVHeader {

        func string(from range: Range<Int>) -> String {
            String(
                data: data.subdata(in: range),
                encoding: .ascii
            ) ?? ""
        }

        func uint16(from offset: Int) -> UInt16 {
            data.withUnsafeBytes {
                $0.load(fromByteOffset: offset, as: UInt16.self)
            }
        }

        func uint32(from offset: Int) -> UInt32 {
            data.withUnsafeBytes {
                $0.load(fromByteOffset: offset, as: UInt32.self)
            }
        }

        return WAVHeader(
            chunkID: string(from: 0..<4),
            chunkSize: uint32(from: 4),
            format: string(from: 8..<12),

            subchunk1ID: string(from: 12..<16),
            subchunk1Size: uint32(from: 16),
            audioFormat: uint16(from: 20),
            numChannels: uint16(from: 22),
            sampleRate: uint32(from: 24),
            byteRate: uint32(from: 28),
            blockAlign: uint16(from: 32),
            bitsPerSample: uint16(from: 34),

            subchunk2ID: string(from: 36..<40),
            subchunk2Size: uint32(from: 40)
        )
    }
}