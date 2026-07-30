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

        transport.open()

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

        transport.open()

        let reader = USBPacketReader(
            transport: transport
        )

        let packet = try reader.nextPacket()

        #expect(packet.isEmpty)
    }

    @Test("Should read two packets sequentially")
    func readSequentialPackets() throws {

        let packet1 = Data([0x01, 0x02])
        let packet2 = Data([0x03, 0x04])

        let transport = MockTransport(
            packets: [
                packet1,
                packet2
            ]
        )

        transport.open()

        let reader = USBPacketReader(
            transport: transport
        )

        let first = try reader.nextPacket()
        let second = try reader.nextPacket()

        #expect(first == packet1)
        #expect(second == packet2)
    }

    @Test("Should return empty packet after EOF")
    func endOfStream() throws {

        let transport = MockTransport(
            packets: [
                Data([0x10])
            ]
        )

        transport.open()

        let reader = USBPacketReader(
            transport: transport
        )

        _ = try reader.nextPacket()

        let eof = try reader.nextPacket()

        #expect(eof.isEmpty)
    }

    @Test("Should support large packet")
    func largePacket() throws {

        let payload = Data(
            repeating: 0x55,
            count: 4096
        )

        let transport = MockTransport(
            packets: [
                payload
            ]
        )

        transport.open()

        let reader = USBPacketReader(
            transport: transport
        )

        let packet = try reader.nextPacket()

        #expect(packet.count == 4096)
        #expect(packet == payload)
    }

    @Test("Should preserve packet order")
    func preserveOrder() throws {

        let packets = [
            Data([0x01]),
            Data([0x02]),
            Data([0x03]),
            Data([0x04])
        ]

        let transport = MockTransport(
            packets: packets
        )

        transport.open()

        let reader = USBPacketReader(
            transport: transport
        )

        for expected in packets {

            let received = try reader.nextPacket()

            #expect(received == expected)
        }
    }

}