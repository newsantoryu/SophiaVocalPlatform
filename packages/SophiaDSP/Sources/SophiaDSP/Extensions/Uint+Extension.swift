import Foundation

public extension Data {

    func uint16LE(at offset: Int) -> UInt16 {

        let b0 = UInt16(self[offset])
        let b1 = UInt16(self[offset + 1]) << 8

        return b0 | b1
    }

    func int16LE(at offset: Int) -> Int16 {

        Int16(bitPattern: uint16LE(at: offset))
    }

    func uint32LE(at offset: Int) -> UInt32 {

        let b0 = UInt32(self[offset])
        let b1 = UInt32(self[offset + 1]) << 8
        let b2 = UInt32(self[offset + 2]) << 16
        let b3 = UInt32(self[offset + 3]) << 24

        return b0 | b1 | b2 | b3
    }

    func string(at offset: Int, length: Int) -> String {

        String(
            data: subdata(in: offset..<(offset + length)),
            encoding: .ascii
        ) ?? ""
    }

}