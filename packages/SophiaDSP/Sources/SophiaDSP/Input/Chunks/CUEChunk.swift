import Foundation

public struct CUEChunk {

    public let payload:Data

    public init(payload: Data) {
        self.payload = payload
    }

}