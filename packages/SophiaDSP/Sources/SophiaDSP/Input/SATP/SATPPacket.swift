import Foundation

public struct SATPPacket: Sendable {

    public let header: SATPHeader

    public let payload: Data

    public init(
        header: SATPHeader,
        payload: Data
    ) {
        self.header = header
        self.payload = payload
    }
}