import Foundation

public struct FMTChunkParser: ChunkParser {
    
    public typealias Chunk = WAVChunk
    public typealias Output = WAVFormatChunk

    public init() {}

    public func parse(
        chunk: WAVChunk
    ) throws -> WAVFormatChunk {
        
        guard chunk.id == .fmt else {
            throw WAVError.invalidDataChunk
        }
        
        let payload = chunk.payload

        guard payload.count >= 16 else {
            throw WAVError.invalidFormatChunk
        }

        return WAVFormatChunk(
            audioFormat: payload.uint16LE(at: 0), 
            numChannels: payload.uint16LE(at: 2), 
            sampleRate: payload.uint32LE(at: 4), 
            byteRate: payload.uint32LE(at: 8), 
            blockAlign: payload.uint16LE(at: 12), 
            bitsPerSample: payload.uint16LE(at: 14)
        )
    }
}