import Foundation

public struct SMPLChunkParser: ChunkParser {

    public typealias Chunk = WAVChunk
    public typealias Output = SMPLChunk

    public init(){}

    public func parse(chunk: WAVChunk) throws -> SMPLChunk {
    
        guard chunk.id == .smpl else {
            throw WAVError.invalidChunk
        }

        return SMPLChunk(payload: chunk.payload)
    }
}