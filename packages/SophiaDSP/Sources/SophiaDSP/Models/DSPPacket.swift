import Foundation

public struct DSPPacket {

    public let frequency: Float?
    public let rms: Float
    public let isVoice: Bool
    public let confidence: Float
    public let timestamp: TimeInterval

    public init(
        frequency: Float?,
        rms: Float,
        isVoice: Bool,
        confidence: Float,
        timestamp: TimeInterval = Date().timeIntervalSince1970
    ) {
        self.frequency = frequency
        self.rms = rms
        self.isVoice = isVoice
        self.confidence = confidence
        self.timestamp = timestamp
    }
}