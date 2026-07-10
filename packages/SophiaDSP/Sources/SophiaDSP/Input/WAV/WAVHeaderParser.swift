import Foundation

public enum WAVHeaderParser {

    // MARK: - Public

    public static func parse(
        from data: Data
    ) throws -> WAVHeader {

        guard data.count >= 44 else {
            throw WAVError.invalidRIFFHeader
        }

        return WAVHeader(
            chunkID: string(from: data, range: 0..<4),
            chunkSize: uint32(from: data, offset: 4),
            format: string(from: data, range: 8..<12),

            subchunk1ID: string(from: data, range: 12..<16),
            subchunk1Size: uint32(from: data, offset: 16),
            audioFormat: uint16(from: data, offset: 20),
            numChannels: uint16(from: data, offset: 22),
            sampleRate: uint32(from: data, offset: 24),
            byteRate: uint32(from: data, offset: 28),
            blockAlign: uint16(from: data, offset: 32),
            bitsPerSample: uint16(from: data, offset: 34),

            subchunk2ID: string(from: data, range: 36..<40),
            subchunk2Size: uint32(from: data, offset: 40)
        )
    }

    // MARK: - Helpers

    private static func string(
        from data: Data,
        range: Range<Int>
    ) -> String {

        String(
            data: data.subdata(in: range),
            encoding: .ascii
        ) ?? ""
    }

    private static func uint16(
        from data: Data,
        offset: Int
    ) -> UInt16 {

        data.withUnsafeBytes {
            $0.load(
                fromByteOffset: offset,
                as: UInt16.self
            )
        }
    }

    private static func uint32(
        from data: Data,
        offset: Int
    ) -> UInt32 {

        data.withUnsafeBytes {
            $0.load(
                fromByteOffset: offset,
                as: UInt32.self
            )
        }
    }
}