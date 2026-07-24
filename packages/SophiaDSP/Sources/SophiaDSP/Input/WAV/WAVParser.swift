import Foundation

public struct WAVParser {

    public init() {}

    public func parse(
        from data: Data
    ) throws -> WAVFile {

        let riff = try RIFFParser().parse(
            from: data
        )

        let header = try WAVHeaderParser().parse(
            riff: riff
        )

        return WAVFile(
            header: header,
            chunks: riff.chunks
        )

    }

}