import Foundation

public protocol ChunkParser {

    associatedtype Chunk
    associatedtype Output

    func parse(
        chunk: Chunk
    ) throws -> Output
}