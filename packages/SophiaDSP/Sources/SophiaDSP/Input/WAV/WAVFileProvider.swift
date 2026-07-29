import Foundation

public final class WAVFileProvider: AudioBufferProvider {

    // MARK: - Properties

    private let wav: WAVFile
    private let pcmData: Data
    private let bufferSize: Int

    private var currentOffset = 0
    private var isRunning = false

    // MARK: - Initializers

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

        self.pcmData = wav.data.pcmData
        self.bufferSize = bufferSize

        try validate(wav.format)

        guard !pcmData.isEmpty else {
            throw AudioInputError.invalidAudioData
        }
    }

    // MARK: - AudioBufferProvider

    public func start(
        onBuffer: @escaping ([Float]) -> Void
    ) throws {

        guard !isRunning else {
            return
        }

        isRunning = true
        currentOffset = 0

        let bytesPerSample = wav.format.bytesPerSample

        while isRunning && currentOffset < pcmData.count {

            let requestedBytes = bufferSize * bytesPerSample

            let availableBytes = min(
                requestedBytes,
                pcmData.count - currentOffset
            )

            let sampleCount = availableBytes / bytesPerSample

            var samples: [Float] = []
            samples.reserveCapacity(sampleCount)

            for index in 0..<sampleCount {

                let offset = currentOffset + index * bytesPerSample

                let sample = pcmData.int16LE(at: offset)

                let normalized: Float

                if sample == Int16.min {
                    normalized = -1.0
                } else {
                    normalized = Float(sample) / Float(Int16.max)
                }

                samples.append(normalized)
            }

            currentOffset += availableBytes

            if !samples.isEmpty {
                onBuffer(samples)
            }
        }

        isRunning = false
    }

    public func stop() {
        isRunning = false
    }

    // MARK: - Validation

    private func validate(
        _ format: WAVFormatChunk
    ) throws {

        guard format.audioFormat == WAVFormat.pcm.rawValue else {
            throw WAVError.unsupportedAudioFormat
        }

        guard format.bitsPerSample == 16 else {
            throw WAVError.unsupportedBitDepth
        }

        guard format.numChannels == 1 else {
            throw WAVError.unsupportedChannelConfiguration
        }
    }
}