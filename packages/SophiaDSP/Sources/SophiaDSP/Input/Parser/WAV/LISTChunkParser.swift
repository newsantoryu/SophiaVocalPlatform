import Foundation

public struct LISTChunkParser: ChunkParser {

    public typealias Chunk = WAVChunk
    public typealias Output = LISTChunk

    public init(){}

    public func parse(chunk: WAVChunk) throws -> LISTChunk {
        
        guard chunk.id == .list else {
            throw WAVError.invalidChunk
        }
        return LISTChunk(payload: chunk.payload)
    }
}