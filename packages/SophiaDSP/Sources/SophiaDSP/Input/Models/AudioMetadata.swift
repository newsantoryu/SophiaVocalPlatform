import Foundation

public struct AudioMetadata: Equatable {

    public let sampleRate: Float
    public let channels: Int
    public let bitDepth: Int
    public let codec: AudioCodec
    public let duration: TimeInterval?

    public init(
        sampleRate: Float,
        channels: Int,
        bitDepth: Int,
        codec: AudioCodec,
        duration: TimeInterval?
    ) {
        self.sampleRate = sampleRate
        self.channels = channels
        self.bitDepth = bitDepth
        self.codec = codec  
        self.duration = duration
    }
}