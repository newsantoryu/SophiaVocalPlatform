import Foundation
import Testing
@testable import SophiaDSP

@Suite("USB Packet Tests")
struct USBPacketTests {
    @Test("Should preserve payload") 
    func preservePayload() {
        
        let payload = Data([1,2,3,4])

        let packet = USBPacket(
            sequence: 10,
            timestamp: 100,
             payload: payload
        )

        #expect(packet.payload == payload)
    }
    

    @Test("Should preserve sequence") 
    func preserveSequence() {
        
        let packet = USBPacket(
            sequence: 42,
            timestamp: 0,
            payload: Data()
        )

        #expect(packet.sequence == 42)
    }

    @Test("Should preserve timestamp")
    func preserveTimestamp() {
        
        let packet = USBPacket(
            sequence: 0, 
            timestamp: 9999, 
            payload: Data()
            
        )

        #expect(packet.timestamp == 9999)
    }


}