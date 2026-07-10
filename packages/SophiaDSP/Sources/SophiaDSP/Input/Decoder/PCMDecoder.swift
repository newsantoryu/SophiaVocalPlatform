import Foundation

public protocol PCMDecoder {

    var format: PCMFormat { get }

    func decode(
        _ data: Data
    ) throws -> [Float]
}