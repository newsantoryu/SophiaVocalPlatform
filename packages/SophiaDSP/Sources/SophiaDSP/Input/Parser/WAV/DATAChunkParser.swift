import Foundation

public struct DATAChunkParser: ChunkParser {

    public typealias Chunk = WAVChunk
    public typealias Output = DATAChunk

    public init()  {}

    public func parse(chunk: WAVChunk) throws -> DATAChunk {
    
        guard chunk.id == .data else {
            throw WAVError.invalidDataChunk
        }

        return DATAChunk(pcmData: chunk.payload)
    }
}