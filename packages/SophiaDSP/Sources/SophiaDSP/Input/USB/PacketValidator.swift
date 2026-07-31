import Foundation

public struct PacketValidator {

    public init() {}

    public func validate(
        header: SATPHeader,
        payload: Data
    ) throws -> SATPPacket {

        guard payload.count == Int(header.payloadSize) else {
            throw SATPError.invalidPayload
        }

        let crc = CRC16.calculate(payload)

        guard crc == header.crc else {
            throw SATPError.invalidCRC
        }

        return SATPPacket(
            header: header,
            payload: payload
        )

    }

}