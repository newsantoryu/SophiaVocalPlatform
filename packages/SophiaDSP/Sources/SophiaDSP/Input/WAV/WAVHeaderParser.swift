import Foundation

public struct WAVHeaderParser {

    public init() {}

    public func parse(
        riff: RIFFFile
    ) throws -> WAVHeader {

        guard riff.format == "WAVE" else {
            throw WAVError.invalidHeader
        }

        guard
            let fmt = riff.chunks.chunk(.fmt),
            let data = riff.chunks.chunk(.data)
        else {
            throw WAVError.invalidHeader
        }

        let payload = fmt.payload

        guard payload.count >= 16 else {
            throw WAVError.invalidHeader
        }

        func uint16(_ offset: Int) -> UInt16 {

            payload.withUnsafeBytes {

                UInt16(
                    littleEndian: $0.load(
                        fromByteOffset: offset,
                        as: UInt16.self
                    )
                )

            }

        }

        func uint32(_ offset: Int) -> UInt32 {

            payload.withUnsafeBytes {

                UInt32(
                    littleEndian: $0.load(
                        fromByteOffset: offset,
                        as: UInt32.self
                    )
                )

            }

        }

        return WAVHeader(

            chunkID: riff.chunkID,
            chunkSize: riff.chunkSize,
            format: riff.format,

            subchunk1ID: "fmt ",
            subchunk1Size: fmt.size,
            audioFormat: uint16(0),
            numChannels: uint16(2),
            sampleRate: uint32(4),
            byteRate: uint32(8),
            blockAlign: uint16(12),
            bitsPerSample: uint16(14),

            subchunk2ID: "data",
            subchunk2Size: data.size
        )

    }

}