import Foundation

public final class WAVDecoder {

    // MARK: - Public Properties

    public let header: WAVHeader
    public let format: PCMFormat

    public var sampleRate: UInt32 {
        header.sampleRate
    }

    public var channels: UInt16 {
        header.numChannels
    }

    public var bitDepth: UInt16 {
        header.bitsPerSample
    }

    // MARK: - Private Properties

    private let wavFile: WAVFile?
    private let decoder: PCMDecoder

    // MARK: - Initializers

    public init(path: String) throws {

        let fileData = try Data(
            contentsOf: URL(fileURLWithPath: path)
        )

        let wav = try WAVParser().parse(
            from: fileData
        )

        self.wavFile = wav
        self.header = wav.header

        self.format = PCMFormat(
            bitDepth: wav.bitDepth,
            sampleRate: wav.sampleRate,
            channels: wav.channels
        )

        self.decoder = try AudioDecoderFactory.makeDecoder(
            format: format
        )
    }

    /// Utilizado principalmente pelos testes.
    public init(header: WAVHeader) throws {

        self.wavFile = nil
        self.header = header

        self.format = PCMFormat(
            bitDepth: Int(header.bitsPerSample),
            sampleRate: Float(header.sampleRate),
            channels: Int(header.numChannels)
        )

        self.decoder = try AudioDecoderFactory.makeDecoder(
            format: format
        )
    }

    // MARK: - Public

    public func decode() throws -> [Float] {

        guard
            let wav = wavFile,
            let audioChunk = wav.audioChunk
        else {
            throw AudioInputError.invalidAudioData
        }

        return try decoder.decode(
            audioChunk.payload
        )
    }

    public func decode(
        data: Data
    ) throws -> [Float] {

        try decoder.decode(data)

    }

}