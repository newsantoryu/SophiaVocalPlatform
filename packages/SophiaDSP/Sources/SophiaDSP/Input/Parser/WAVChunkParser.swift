 import Foundation

 public protocol WAVChunkParser {
    associatedtype Output
    func parse(chunck: WAVChunk) throws -> Output
}