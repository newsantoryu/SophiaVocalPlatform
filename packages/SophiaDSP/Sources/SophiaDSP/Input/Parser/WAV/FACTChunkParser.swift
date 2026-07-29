import Foundation

public struct FACTChunkParser: ChunkParser {

    public typealias Chunk = WAVChunk
    public typealias Output = FACTChunk

    public init(){}

    public func parse(chunk: WAVChunk) throws -> FACTChunk {
        
        guard chunk.id == .fact else {
            throw WAVError.invalidChunk
        }

        return FACTChunk(payload: chunk.payload)
    }
}