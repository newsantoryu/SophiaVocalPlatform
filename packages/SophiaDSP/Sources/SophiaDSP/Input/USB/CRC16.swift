import Foundation

public enum CRC16 {

    private static let polynomial: UInt16 = 0x1021
    private static let initialValue: UInt16 = 0xFFFF

    public static func calculate(_ data: Data) -> UInt16 {

        var crc = initialValue

        for byte in data {

            crc ^= UInt16(byte) << 8

            for _ in 0..<8 {

                if (crc & 0x8000) != 0 {
                    crc = (crc << 1) ^ polynomial
                } else {
                    crc <<= 1
                }

            }

        }

        return crc
    }

}