import Foundation

public final class WAVSource: AudioSource {

    // MARK: - Properties

    public let metadata: AudioMetadata

    private let url: URL
    private let wav: WAVFile

    private var isOpen = false
    private var hasRead = false

    // MARK: - Init

    public init(path: String) throws {

        self.url = URL(fileURLWithPath: path)

        let data = try Data(contentsOf: url)

        self.wav = try WAVParser().parse(
            from: data
        )

        guard wav.format.audioFormat == WAVFormat.pcm.rawValue else {
            throw AudioInputError.unsupportedFormat
        }

        let duration =
            Double(wav.data.pcmData.count) /
            Double(wav.format.byteRate)

        self.metadata = AudioMetadata(
            sampleRate: Float(wav.format.sampleRate),
            channels: Int(wav.format.numChannels),
            bitDepth: Int(wav.format.bitsPerSample),
            codec: .wav,
            duration: duration
        )
    }

    // MARK: - AudioSource

    public func open() throws {

        isOpen = true
        hasRead = false

    }

    public func read() throws -> Data? {

        guard isOpen else {
            return nil
        }

        guard !hasRead else {
            return nil
        }

        hasRead = true

        return wav.data.pcmData
    }

    public func close() {

        isOpen = false

    }

}