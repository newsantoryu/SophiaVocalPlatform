import Foundation

public enum USBProtocol {

    public static let sync0: UInt8 = 0xAA

    public static let sync1: UInt8 = 0x55

    public static let headerSize = 18

    public static let maxPayloadSize = 4096
}