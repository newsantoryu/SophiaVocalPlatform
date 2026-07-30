import Foundation

public struct DataReader {

    // MARK: - Properties

    private let data: Data
    private var offset: Int = 0

    // MARK: - Init

    public init(data: Data) {
        self.data = data
    }

    // MARK: - Read

    public mutating func readUInt8() throws -> UInt8 {

        guard offset + 1 <= data.count else {
            throw DataReaderError.endOfData
        }

        defer { offset += 1 }

        return data[offset]
    }

    public mutating func readUInt16() throws -> UInt16 {

        guard offset + 2 <= data.count else {
            throw DataReaderError.endOfData
        }

        defer { offset += 2 }

        return data
            .subdata(in: offset..<offset+2)
            .withUnsafeBytes {
                UInt16(littleEndian: $0.load(as: UInt16.self))
            }
    }

    public mutating func readUInt32() throws -> UInt32 {

        guard offset + 4 <= data.count else {
            throw DataReaderError.endOfData
        }

        defer { offset += 4 }

        return data
            .subdata(in: offset..<offset+4)
            .withUnsafeBytes {
                UInt32(littleEndian: $0.load(as: UInt32.self))
            }
    }

    public mutating func readUInt64() throws -> UInt64 {

        guard offset + 8 <= data.count else {
            throw DataReaderError.endOfData
        }

        defer { offset += 8 }

        return data
            .subdata(in: offset..<offset+8)
            .withUnsafeBytes {
                UInt64(littleEndian: $0.load(as: UInt64.self))
            }
    }

    public mutating func readData(count: Int) throws -> Data {

        guard offset + count <= data.count else {
            throw DataReaderError.endOfData
        }

        defer { offset += count }

        return data.subdata(in: offset..<offset+count)
    }
}