import Foundation
import Testing
@testable import SophiaDSP

@Suite("(USB Packet Header Tests)")
struct USBPacketHeaderTests {


    @Test("Should preserve payload size")
     func preservePayloadSize()  {
        
        let header = USBPacketHeader(
            payloadSize: 512, 
            crc: 100
        )

        #expect(header.payloadSize == 512)
    }

    @Test("Should preserve crc") 
    func preserveCRC() {
        
        let header = USBPacketHeader(
            payloadSize: 128, 
            crc: 999
        )

        #expect(header.crc == 999)
    }

    @Test("Should expose sync bytes") 
    func syncBytes() {
        
        #expect(USBPacketHeader.sync0 == 0xAA)
        #expect(USBPacketHeader.sync1 == 0x55)
    }
}