import Foundation

public struct WAVFile {

    // MARK: - Properties

    public let header: WAVHeader

    public let chunks: WAVChunkCollection

    // MARK: - Init

    public init(
        header: WAVHeader,
        chunks: WAVChunkCollection
    ) {
        self.header = header
        self.chunks = chunks
    }

    // MARK: - Public

    /// Chunk que contém os dados PCM
    public var audioChunk: WAVChunk? {
        chunks.chunk(.data)
    }

    /// Chunk de formato
    public var formatChunk: WAVChunk? {
        chunks.chunk(.fmt)
    }

    /// Duração do áudio em segundos
    public var duration: TimeInterval {

        guard header.byteRate > 0 else {
            return 0
        }

        return TimeInterval(header.subchunk2Size)
            / TimeInterval(header.byteRate)
    }

    /// Tamanho do áudio em bytes
    public var audioDataSize: Int {
        Int(header.subchunk2Size)
    }

    /// Frequência de amostragem
    public var sampleRate: Float {
        Float(header.sampleRate)
    }

    /// Quantidade de canais
    public var channels: Int {
        Int(header.numChannels)
    }

    /// Bits por amostra
    public var bitDepth: Int {
        Int(header.bitsPerSample)
    }

    /// Codec do arquivo
    public var codec: AudioCodec {
        .wav
    }

}