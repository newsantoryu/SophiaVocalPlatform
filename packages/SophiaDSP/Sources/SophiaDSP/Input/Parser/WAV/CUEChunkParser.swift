import Foundation

public struct CUEChunkParser: ChunkParser {

    public typealias Chunk = WAVChunk
    public typealias Output = CUEChunk

    public init(){}

    public func parse(chunk: WAVChunk) throws -> CUEChunk {
    
        guard chunk.id == .cue else {
            throw WAVError.invalidChunk
        }

        return CUEChunk(payload: chunk.payload)
    }
}