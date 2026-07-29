import Foundation

public struct BEXTChunkParser: ChunkParser {

    public typealias Chunk = WAVChunk
    public typealias Output = BEXTChunk

    public init() {}

    public func parse(chunk: WAVChunk) throws -> BEXTChunk {
        
        guard chunk.id == .bext else {
            throw WAVError.invalidChunk
        }

        return BEXTChunk(payload: chunk.payload)
    }
}