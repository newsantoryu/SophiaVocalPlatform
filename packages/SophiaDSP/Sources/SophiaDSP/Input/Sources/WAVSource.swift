import Foundation

public final class WAVSource: AudioSource {

    // MARK: - Properties

    public let metadata: AudioMetadata

    private let url: URL
    private let data: Data
    private let wav: WAVFile

    private var isOpen = false
    private var hasRead = false

    // MARK: - Init

    public init(path: String) throws {

        self.url = URL(fileURLWithPath: path)
        self.data = try Data(contentsOf: url)

        self.wav = try WAVParser().parse(
            from: data
        )

        let header = wav.header

        guard header.audioFormat == WAVFormat.pcm.rawValue else {
            throw AudioInputError.unsupportedFormat
        }

        let duration = Double(header.subchunk2Size)
            / Double(header.byteRate)

        self.metadata = AudioMetadata(
            sampleRate: Float(header.sampleRate),
            channels: Int(header.numChannels),
            bitDepth: Int(header.bitsPerSample),
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

        guard let audioChunk = wav.audioChunk else {
            throw WAVError.invalidHeader
        }

        return audioChunk.payload
    }

    public func close() {
        isOpen = false
    }

}