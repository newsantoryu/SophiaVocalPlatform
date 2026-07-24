import Foundation

public struct WAVChunkReader {

    public func read(from data: Data) throws -> [WAVChunk] {

        guard data.count >= 12 else {
            throw WAVError.invalidHeader
        }

        var chunks: [WAVChunk] = []
        var offset = 12

        while offset + 8 <= data.count {
            
            let id = String(
                data: data.subdata(in: offset..<(offset + 4)),
                encoding: .ascii
            ) ?? ""

            let size: UInt32 = data.uint32LE(at: offset + 4)

            let dataOffset = offset + 8

            guard dataOffset + Int(size) <= data.count else {
                break
            }

            let payload = data.subdata(
                in: dataOffset..<(dataOffset + Int(size))
            )

            chunks.append(
                WAVChunk(
                    id: WAVChunkID(rawValue: id) ?? .unknown, 
                    offset: dataOffset, 
                    size: size, 
                    payload: payload
                )
            )

            offset = dataOffset + Int(size)

            if offset % 2 != 0 {
                offset += 1
            }
        }

        return chunks
    }
}