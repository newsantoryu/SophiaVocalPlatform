import Foundation
import Testing
@testable import SophiaDSP

@Suite("Mock Transport Tests")
struct MockTransportTests {

    @Test("Should open transport")
    func openTransport() throws {

        let transport = MockTransport(
            packets: []
        )

        #expect(transport.isOpen == false)

        transport.open()

        #expect(transport.isOpen)
    }

    @Test("Should close transport")
    func closeTransport() throws {

        let transport = MockTransport(
            packets: []
        )

        transport.open()

        transport.close()

        #expect(transport.isOpen == false)
    }

    @Test("Should read packet")
    func readPacket() throws {

        let expected = Data([1,2,3,4])

        let transport = MockTransport(
            packets: [expected]
        )

        transport.open()

        let packet = try transport.read(
            maxLength: 64
        )

        #expect(packet == expected)
    }

    @Test("Should return empty data when queue is empty")
    func readEmptyQueue() throws {

        let transport = MockTransport(
            packets: []
        )

        transport.open()

        let packet = try transport.read(
            maxLength: 64
        )

        #expect(packet.isEmpty)
    }

    @Test("Should throw when disconnected")
    func disconnected() {

        let transport = MockTransport(
            packets: []
        )

        #expect(throws: TransportError.disconnected) {

            _ = try transport.read(
                maxLength: 64
            )

        }
    }
}