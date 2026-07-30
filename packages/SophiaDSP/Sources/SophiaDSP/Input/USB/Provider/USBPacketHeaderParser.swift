import Foundation

public struct USBPacketHeaderParser {

    public init() {}

    public func parse(from data: Data) throws -> USBPacketHeader {

        var reader = DataReader(data: data)

        let sync0 = try reader.readUInt8()
        let sync1 = try reader.readUInt8()

        guard
            sync0 == USBPacketHeader.sync0,
            sync1 == USBPacketHeader.sync1
        else {
            throw USBPacketError.invalidSync
        }

        let sequence = try reader.readUInt32()

        let timestamp = try reader.readUInt64()

        let payloadSize = try reader.readUInt16()

        let crc = try reader.readUInt16()

        return USBPacketHeader(
            sequence: sequence,
            timestamp: timestamp,
            payloadSize: payloadSize,
            crc: crc
        )
    }
}