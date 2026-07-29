import Foundation

public final class WAVDecoder {

    // MARK: - Public Properties

    public let wav: WAVFile

    public let format: PCMFormat

    public var sampleRate: UInt32 {
        wav.format.sampleRate
    }

    public var channels: UInt16 {
        wav.format.numChannels
    }

    public var bitDepth: UInt16 {
        wav.format.bitsPerSample
    }

    // MARK: - Private Properties

    private let decoder: PCMDecoder

    // MARK: - Initializers

    public init(
        path: String
    ) throws {

        let data = try Data(
            contentsOf: URL(fileURLWithPath: path)
        )

        self.wav = try WAVParser().parse(
            from: data
        )

        self.format = PCMFormat(
            bitDepth: Int(wav.format.bitsPerSample),
            sampleRate: Float(wav.format.sampleRate),
            channels: Int(wav.format.numChannels)
        )

        self.decoder = try AudioDecoderFactory.makeDecoder(
            format: format
        )
    }

    /// Utilizado principalmente pelos testes.

    public init(
        wav: WAVFile
    ) throws {

        self.wav = wav

        self.format = PCMFormat(
            bitDepth: Int(wav.format.bitsPerSample),
            sampleRate: Float(wav.format.sampleRate),
            channels: Int(wav.format.numChannels)
        )

        self.decoder = try AudioDecoderFactory.makeDecoder(
            format: format
        )
    }

    // MARK: - Public

    public func decode() throws -> [Float] {

        try decoder.decode(
            wav.data.pcmData
        )

    }

    public func decode(
        data: Data
    ) throws -> [Float] {

        try decoder.decode(data)

    }

}