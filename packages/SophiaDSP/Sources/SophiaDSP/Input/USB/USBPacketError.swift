import Foundation

public enum USBPacketError: Error {

    case invalidSync

    case invalidCRC

    case invalidPayloadSize

    case truncatedPacket

}