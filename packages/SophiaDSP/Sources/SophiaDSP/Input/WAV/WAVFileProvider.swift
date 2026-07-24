import Foundation

public final class WAVFileProvider: AudioBufferProvider {

    // MARK: - Properties

    public let header: WAVHeader

    private let wav: WAVFile

    private let bufferSize: Int

    private var currentOffset = 0

    private var isRunning = false

    // MARK: - Init

    public init(
        path: String,
        bufferSize: Int = 4096
    ) throws {

        let fileData = try Data(
            contentsOf: URL(fileURLWithPath: path)
        )

        self.wav = try WAVParser().parse(
            from: fileData
        )

        self.header = wav.header
        self.bufferSize = bufferSize

        try validate(header)

    }

    // MARK: - AudioBufferProvider

    public func start(
        onBuffer: @escaping ([Float]) -> Void
    ) throws {

        guard let chunk = wav.audioChunk else {
            throw AudioInputError.invalidAudioData
        }

        isRunning = true

        let data = chunk.payload

        let bytesPerSample = 2

        currentOffset = 0

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

                let offset = currentOffset + index * bytesPerSample

                let value = data.int16LE(at: offset)

                let normalized: Float

                if value == Int16.min {
                    normalized = -1
                } else {
                    normalized = Float(value) / Float(Int16.max)
                }

                samples.append(normalized)

            }

            currentOffset += sampleCount * bytesPerSample

            if !samples.isEmpty {
                onBuffer(samples)
            }

        }

    }

    public func stop() {
        isRunning = false
    }

    // MARK: - Validation

    private func validate(
        _ header: WAVHeader
    ) throws {

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