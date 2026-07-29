import Foundation 

public struct SMPLChunk {

    public let payload: Data

    public init(payload: Data) {
        self.payload = payload
    } 
}