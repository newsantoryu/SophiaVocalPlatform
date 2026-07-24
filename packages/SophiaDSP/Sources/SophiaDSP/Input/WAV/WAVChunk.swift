import Foundation

public struct WAVChunk {
    public let id: WAVChunkID
    public let offset: Int
    public let size: UInt32
    public let payload: Data  
}