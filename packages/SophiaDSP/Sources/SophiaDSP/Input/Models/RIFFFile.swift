import Foundation

public struct RIFFFile {

    // MARK: - RIFF Header

    public let chunkID: String
    public let chunkSize: UInt32
    public let format: String

    // MARK: - Chunks

    public let chunks: WAVChunkCollection

    // MARK: - Init

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