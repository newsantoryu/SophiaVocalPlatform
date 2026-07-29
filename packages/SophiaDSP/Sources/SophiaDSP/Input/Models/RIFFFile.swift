public struct RIFFFile {

    // RIFF Header

    public let chunkID: String
    public let chunkSize: UInt32
    public let format: String

    // Todos os chunks encontrados

    public let chunks: WAVChunkCollection

    public init(
        chunkID: String,
        chunkSize: UInt32,
        format: String,
        chunks: WAVChunkCollection
    ) {

        self.chunkID = chunkID
        self.chunkSize = chunkSize
        self.format = format
        self.chunks = chunks
    }
}