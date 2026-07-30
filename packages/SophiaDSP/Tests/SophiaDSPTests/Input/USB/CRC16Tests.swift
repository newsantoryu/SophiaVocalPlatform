import Foundation
import Testing
@testable import SophiaDSP

@Suite("CRC16 Tests")
struct CRC16Tests {

    @Test
    func emptyPayload() {

        let crc = CRC16.calculate(Data())

        #expect(crc == 0xFFFF)

    }

    @Test
    func samePayloadSameCRC() {

        let payload = Data([1,2,3,4])

        #expect(
            CRC16.calculate(payload)
            ==
            CRC16.calculate(payload)
        )

    }

    @Test
    func differentPayloadDifferentCRC() {

        let crc1 = CRC16.calculate(
            Data([1,2,3])
        )

        let crc2 = CRC16.calculate(
            Data([1,2,4])
        )

        #expect(crc1 != crc2)

    }

}