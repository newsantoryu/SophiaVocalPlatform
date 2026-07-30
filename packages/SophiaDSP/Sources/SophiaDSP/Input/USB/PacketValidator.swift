import Foundation

public struct PacketValidator {

    public init() {}

    public func validate(
        header: USBPacketHeader,
        payload: Data
    ) throws -> USBPacket {

        guard payload.count == Int(header.payloadSize) else {
            throw USBPacketError.invalidPayload
        }

        let crc = CRC16.calculate(payload)

        guard crc == header.crc else {
            throw USBPacketError.invalidCRC
        }

        return USBPacket(
            header: header,
            payload: payload
        )

    }

}