import Foundation

public protocol AudioDecoder {

    var sampleRate: Float { get }

    var channels: Int { get }

    var duration: TimeInterval { get }

    func readSamples(
        count: Int
    ) throws -> [Float]?

    func seek(
        to time: TimeInterval
    ) throws

    func close()
}