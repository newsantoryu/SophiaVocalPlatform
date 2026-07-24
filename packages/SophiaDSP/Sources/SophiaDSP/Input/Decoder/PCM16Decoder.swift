import Foundation

public struct PCM16Decoder: PCMDecoder {

    public let format: PCMFormat

    public init(format: PCMFormat) {
        self.format = format
    }

    public func decode(
        _ data: Data
    ) throws -> [Float] {

        let bytesPerSample = format.bytesPerSample

        precondition(bytesPerSample == 2)

        let sampleCount = data.count / bytesPerSample

        var samples: [Float] = []
        samples.reserveCapacity(sampleCount)

        for index in 0..<sampleCount {

            let offset = index * bytesPerSample

            let value = data.int16LE(at: offset)

            samples.append(
                Float(value) / Float(Int16.max)
            )
        }

        return samples
    }
}