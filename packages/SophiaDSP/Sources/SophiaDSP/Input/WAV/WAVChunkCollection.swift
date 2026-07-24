import Foundation

public struct WAVChunkCollection {

    // MARK: - Properties

    private let chunks: [WAVChunk]

    // MARK: - Init

    public init(chunks: [WAVChunk]) {
        self.chunks = chunks
    }

    // MARK: - Public

    public func chunk(
        _ id: WAVChunkID
    ) -> WAVChunk? {

        chunks.first {
            $0.id == id
        }

    }

    public func contains(
        _ id: WAVChunkID
    ) -> Bool {

        chunk(id) != nil

    }

    public var all: [WAVChunk] {
        chunks
    }

}