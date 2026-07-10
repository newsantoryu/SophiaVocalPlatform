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

    private let data: Data?
    private let audioDataOffset: Int
    private let decoder: PCMDecoder

    // MARK: - Initializers

    public init(path: String) throws {

        let fileData = try Data(
            contentsOf: URL(fileURLWithPath: path)
        )

       let header = try WAVHeaderParser.parse(
            from: fileData
        )

        self.header = header
        self.data = fileData
        self.audioDataOffset = 44

        self.format = PCMFormat(
            bitDepth: Int(header.bitsPerSample),
            sampleRate: Float(header.sampleRate),
            channels: Int(header.numChannels)
        )

        self.decoder = try AudioDecoderFactory.makeDecoder(
            format: format
        )
    }

    /// Utilizado principalmente pelos testes.
    public init(header: WAVHeader) throws {

        self.header = header
        self.data = nil
        self.audioDataOffset = 44

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

    /// Decodifica um arquivo WAV carregado pelo init(path:)
    public func decode() throws -> [Float] {

        guard let data else {
            throw AudioInputError.invalidAudioData
        }

        let pcmData = data.subdata(
            in: audioDataOffset..<data.count
        )

        return try decoder.decode(pcmData)
    }

    /// Decodifica dados PCM diretamente.
    public func decode(
        data: Data
    ) throws -> [Float] {

        try decoder.decode(data)
    }
}