import Foundation

final class MockTransport: Transport {

    private var packets: [Data]

    var isOpen = false

    init(packets: [Data]) {
        self.packets = packets
    }

    func open() {
        isOpen = true
    }

    func read(maxLength: Int) throws -> Data {

        guard isOpen else {
            throw TransportError.disconnected
        }

        guard !packets.isEmpty else {
            return Data()
        }

        return packets.removeFirst()
    }

    func write(_ data: Data) throws {}

    func close() {
        isOpen = false
    }
}