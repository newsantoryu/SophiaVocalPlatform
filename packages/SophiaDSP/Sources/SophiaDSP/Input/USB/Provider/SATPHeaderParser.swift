import Foundation

public struct SATPHeaderParser {

    public init() {}

    public func parse(from data: Data) throws -> SATPHeader {

        var reader = DataReader(data: data)

        let sync0 = try reader.readUInt8()
        let sync1 = try reader.readUInt8()

        guard
            sync0 == SATPHeader.sync0,
            sync1 == SATPHeader.sync1
        else {
            throw SATPError.invalidSync
        }

        let sequence = try reader.readUInt32()

        let timestamp = try reader.readUInt64()

        let payloadSize = try reader.readUInt16()

        let crc = try reader.readUInt16()

        return SATPHeader(
            sequence: sequence,
            timestamp: timestamp,
            payloadSize: payloadSize,
            crc: crc
        )
    }
}