import Foundation

public final class SerialTransport: Transport {

    public let device: String

    public private(set) var isOpen = false

    public init(device: String) {
        self.device = device
    }

    public func open() throws {
        // Sprint seguinte
    }

    public func read(maxLength: Int) throws -> Data {
        Data()
    }

    public func write(_ data: Data) throws {}

    public func close() {}
}