import Foundation
import Testing
@testable import SophiaDSP

@Suite("SATP Packet Tests")
struct SATPPacketTests {

    @Test("Should preserve payload")
    func preservePayload() {

        let payload = Data([1,2,3,4])

        let header = SATPHeader(
            sequence: 10,
            timestamp: 100,
            payloadSize: UInt16(payload.count),
            crc: 55
        )

        let packet = SATPPacket(
            header: header,
            payload: payload
        )

        #expect(packet.payload == payload)
    }

    @Test("Should preserve sequence")
    func preserveSequence() {

        let header = SATPHeader(
            sequence: 42,
            timestamp: 0,
            payloadSize: 0,
            crc: 0
        )

        let packet = SATPPacket(
            header: header,
            payload: Data()
        )

        #expect(packet.header.sequence == 42)
    }

    @Test("Should preserve timestamp")
    func preserveTimestamp() {

        let header = SATPHeader(
            sequence: 0,
            timestamp: 9999,
            payloadSize: 0,
            crc: 0
        )

        let packet = SATPPacket(
            header: header,
            payload: Data()
        )

        #expect(packet.header.timestamp == 9999)
    }

    @Test("Should preserve payload size")
    func preservePayloadSize() {

        let payload = Data(repeating: 0, count: 128)

        let header = SATPHeader(
            sequence: 0,
            timestamp: 0,
            payloadSize: UInt16(payload.count),
            crc: 0
        )

        let packet = SATPPacket(
            header: header,
            payload: payload
        )

        #expect(packet.header.payloadSize == 128)
    }

    @Test("Should preserve crc")
    func preserveCRC() {

        let header = SATPHeader(
            sequence: 0,
            timestamp: 0,
            payloadSize: 0,
            crc: 777
        )

        let packet = SATPPacket(
            header: header,
            payload: Data()
        )

        #expect(packet.header.crc == 777)
    }
}