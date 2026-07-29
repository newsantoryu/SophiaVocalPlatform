import Foundation

public struct BEXTChunk {

    public let payload:Data

    public init(payload: Data) {
        self.payload = payload
    }
}