import Foundation

public struct PCMFormat: Equatable, Sendable {

    // MARK: - Audio Format

    public let bitDepth: Int
    public let sampleRate: Float
    public let channels: Int

    // MARK: - Computed

    public var bytesPerSample: Int {
        bitDepth / 8
    }

    public var isMono: Bool {
        channels == 1
    }

    public var isStereo: Bool {
        channels == 2
    }

    // MARK: - Init

    public init(
        bitDepth: Int,
        sampleRate: Float,
        channels: Int
    ) {
        self.bitDepth = bitDepth
        self.sampleRate = sampleRate
        self.channels = channels
    }
}