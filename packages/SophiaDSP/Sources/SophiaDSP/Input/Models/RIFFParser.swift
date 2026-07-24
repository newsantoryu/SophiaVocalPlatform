import Foundation

public struct RIFFParser {

    public init() {}

    public func parse(
        from data: Data
    ) throws -> RIFFFile {

        guard data.count >= 12 else {
            throw WAVError.invalidHeader
        }

        func string(at offset: Int, length: Int) -> String {

            String(
                data: data.subdata(
                    in: offset..<(offset + length)
                ),
                encoding: .ascii
            ) ?? ""

        }

        func uint32(at offset: Int) -> UInt32 {

            data.uint32LE(at: offset)

        }

        let chunkID = string(at: 0, length: 4)
        let chunkSize = uint32(at: 4)
        let format = string(at: 8, length: 4)

        guard chunkID == "RIFF" else {
            throw WAVError.invalidHeader
        }

        let chunks = try WAVChunkReader().read(
            from: data
        )

        return RIFFFile(
            chunkID: chunkID,
            chunkSize: chunkSize,
            format: format,
            chunks: WAVChunkCollection(
                chunks: chunks
            )
        )
    }

}