import Foundation

public struct WAVHeader {

    // MARK: - RIFF

    public let chunkID: String
    public let chunkSize: UInt32
    public let format: String

    // MARK: - FMT

    public let subchunk1ID: String
    public let subchunk1Size: UInt32
    public let audioFormat: UInt16
    public let numChannels: UInt16
    public let sampleRate: UInt32
    public let byteRate: UInt32
    public let blockAlign: UInt16
    public let bitsPerSample: UInt16

    // MARK: - DATA

    public let subchunk2ID: String
    public let subchunk2Size: UInt32
}

// MARK: - Parser

public extension WAVHeader {

    static func parse(from data: Data) throws -> WAVHeader {

        guard data.count >= 44 else {
            throw WAVError.invalidHeader
        }

        func string(at offset: Int, length: Int) -> String {
            let range = offset..<(offset + length)

            return String(
                data: data.subdata(in: range),
                encoding: .ascii
            ) ?? ""
        }

        func uint16(at offset: Int) -> UInt16 {
            data.uint16LE(at: offset)
        }

        func uint32(at offset: Int) -> UInt32 {
            data.uint32LE(at: offset)
        }

        let header = WAVHeader(
            chunkID: string(at: 0, length: 4),
            chunkSize: uint32(at: 4),
            format: string(at: 8, length: 4),

            subchunk1ID: string(at: 12, length: 4),
            subchunk1Size: uint32(at: 16),
            audioFormat: uint16(at: 20),
            numChannels: uint16(at: 22),
            sampleRate: uint32(at: 24),
            byteRate: uint32(at: 28),
            blockAlign: uint16(at: 32),
            bitsPerSample: uint16(at: 34),

            subchunk2ID: string(at: 36, length: 4),
            subchunk2Size: uint32(at: 40)
        )

        guard header.chunkID == "RIFF" else {
            throw WAVError.invalidHeader
        }

        guard header.format == "WAVE" else {
            throw WAVError.invalidHeader
        }

        guard header.subchunk1ID == "fmt " else {
            throw WAVError.invalidHeader
        }

        guard header.subchunk2ID == "data" else {
            throw WAVError.invalidHeader
        }

        return header
    }
}