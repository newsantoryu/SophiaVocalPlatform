import Foundation
import Testing
@testable import SophiaDSP

@Suite("USB Packet Tests")
struct USBPacketTests {

    @Test("Should preserve payload")
    func preservePayload() {

        let payload = Data([1,2,3,4])

        let header = USBPacketHeader(
            sequence: 10,
            timestamp: 100,
            payloadSize: UInt16(payload.count),
            crc: 55
        )

        let packet = USBPacket(
            header: header,
            payload: payload
        )

        #expect(packet.payload == payload)
    }

    @Test("Should preserve sequence")
    func preserveSequence() {

        let header = USBPacketHeader(
            sequence: 42,
            timestamp: 0,
            payloadSize: 0,
            crc: 0
        )

        let packet = USBPacket(
            header: header,
            payload: Data()
        )

        #expect(packet.header.sequence == 42)
    }

    @Test("Should preserve timestamp")
    func preserveTimestamp() {

        let header = USBPacketHeader(
            sequence: 0,
            timestamp: 9999,
            payloadSize: 0,
            crc: 0
        )

        let packet = USBPacket(
            header: header,
            payload: Data()
        )

        #expect(packet.header.timestamp == 9999)
    }

    @Test("Should preserve payload size")
    func preservePayloadSize() {

        let payload = Data(repeating: 0, count: 128)

        let header = USBPacketHeader(
            sequence: 0,
            timestamp: 0,
            payloadSize: UInt16(payload.count),
            crc: 0
        )

        let packet = USBPacket(
            header: header,
            payload: payload
        )

        #expect(packet.header.payloadSize == 128)
    }

    @Test("Should preserve crc")
    func preserveCRC() {

        let header = USBPacketHeader(
            sequence: 0,
            timestamp: 0,
            payloadSize: 0,
            crc: 777
        )

        let packet = USBPacket(
            header: header,
            payload: Data()
        )

        #expect(packet.header.crc == 777)
    }
}