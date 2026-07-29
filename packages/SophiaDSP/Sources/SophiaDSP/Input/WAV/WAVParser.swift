import Foundation

public struct WAVParser {

    public init() {}

    public func parse(
        from data: Data
    ) throws -> WAVFile {

        let riff = try RIFFParser().parse(from: data)

        guard
            let fmtChunk = riff.chunks.chunk(.fmt),
            let dataChunk = riff.chunks.chunk(.data)
        else {
            throw WAVError.invalidHeader
        }

        let format = try FMTChunkParser().parse(
            chunk: fmtChunk
        )

        let pcm = try DATAChunkParser().parse(
            chunk: dataChunk
        )

        let list = riff.chunks.chunk(.list)
            .flatMap {
                try? LISTChunkParser().parse(chunk: $0)
            }

        let fact = riff.chunks.chunk(.fact)
            .flatMap {
                try? FACTChunkParser().parse(chunk: $0)
            }

        let cue = riff.chunks.chunk(.cue)
            .flatMap {
                try? CUEChunkParser().parse(chunk: $0)
            }

        let smpl = riff.chunks.chunk(.smpl)
            .flatMap {
                try? SMPLChunkParser().parse(chunk: $0)
            }

        let bext = riff.chunks.chunk(.bext)
            .flatMap {
                try? BEXTChunkParser().parse(chunk: $0)
            }

        return WAVFile(
            riff: riff,
            format: format,
            data: pcm,
            list: list,
            fact: fact,
            cue: cue,
            smpl: smpl,
            bext: bext
        )
    }
}