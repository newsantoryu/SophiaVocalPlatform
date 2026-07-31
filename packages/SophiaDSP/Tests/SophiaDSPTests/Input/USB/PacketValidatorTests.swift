import Foundation
import Testing
@testable import SophiaDSP

@Suite("Packet Validator Tests")
struct PacketValidatorTests {

    @Test
    func validPacket() throws {

        let payload = Data([1,2,3])

        let header = SATPHeader(
            sequence: 1,
            timestamp: 100,
            payloadSize: 3,
            crc: CRC16.calculate(payload)
        )

        let validator = PacketValidator()

        let packet = try validator.validate(
            header: header,
            payload: payload
        )

        #expect(packet.payload == payload)

    }

    @Test
    func invalidCRC() {

        let payload = Data([1,2,3])

        let header = SATPHeader(
            sequence: 1,
            timestamp: 0,
            payloadSize: 3,
            crc: 0
        )

        let validator = PacketValidator()

        #expect(throws: SATPError.self) {

            try validator.validate(
                header: header,
                payload: payload
            )

        }

    }

}