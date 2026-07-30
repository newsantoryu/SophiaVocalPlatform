import Foundation
import Testing
@testable import SophiaDSP

@Suite("USB Packet Header Tests")
struct USBPacketHeaderTests {

    @Test("Should preserve payload size")
    func preservePayloadSize() {

        let header = USBPacketHeader(
            sequence: 1,
            timestamp: 100,
            payloadSize: 512,
            crc: 100
        )

        #expect(header.payloadSize == 512)
    }

    @Test("Should preserve crc")
    func preserveCRC() {

        let header = USBPacketHeader(
            sequence: 5,
            timestamp: 200,
            payloadSize: 128,
            crc: 999
        )

        #expect(header.crc == 999)
    }

    @Test("Should preserve sequence")
    func preserveSequence() {

        let header = USBPacketHeader(
            sequence: 42,
            timestamp: 0,
            payloadSize: 64,
            crc: 10
        )

        #expect(header.sequence == 42)
    }

    @Test("Should preserve timestamp")
    func preserveTimestamp() {

        let header = USBPacketHeader(
            sequence: 0,
            timestamp: 9999,
            payloadSize: 64,
            crc: 10
        )

        #expect(header.timestamp == 9999)
    }

    @Test("Should expose sync bytes")
    func exposeSyncBytes() {

        #expect(USBPacketHeader.sync0 == 0xAA)
        #expect(USBPacketHeader.sync1 == 0x55)
    }
}