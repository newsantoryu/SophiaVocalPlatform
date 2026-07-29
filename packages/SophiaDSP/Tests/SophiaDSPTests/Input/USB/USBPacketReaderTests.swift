import Foundation
import Testing
@testable import SophiaDSP

@Suite("USB Packet Reader Tests")
struct USBPacketReaderTests {

    @Test("Should read packet from transport")
    func readPacket() throws {

        let expected = Data([
            0x01,
            0x02,
            0x03,
            0x04
        ])

        let transport = MockTransport(
            packets: [expected]
        )

        try transport.open()

        let reader = USBPacketReader(
            transport: transport
        )

        let packet = try reader.nextPacket()

        #expect(packet == expected)
    }

    @Test("Should return empty packet")
    func emptyPacket() throws {

        let transport = MockTransport(
            packets: []
        )

        try transport.open()

        let reader = USBPacketReader(
            transport: transport
        )

        let packet = try reader.nextPacket()

        #expect(packet.isEmpty)
    }
}