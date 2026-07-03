import Foundation

public struct DSPFrame {

    // MARK: - Raw Audio

    public var samples: [Float]

    // MARK: - Analysis

    public var frequency: Float?
    public var confidence: Float?
    public var amplitude: Float?
    public var rms: Float?

    // MARK: - Voice Activity Detection

    public var isSilent: Bool = false
    public var isVoiceActive: Bool = false

    // MARK: - Metadata

    public var timestamp: TimeInterval

    // MARK: - Init

    public init(
        samples: [Float],
        frequency: Float? = nil,
        confidence: Float? = nil,
        amplitude: Float? = nil,
        rms: Float? = nil,
        isSilent: Bool = false,
        isVoiceActive: Bool = false,
        timestamp: TimeInterval = Date().timeIntervalSince1970
    ) {
        self.samples = samples
        self.frequency = frequency
        self.confidence = confidence
        self.amplitude = amplitude
        self.rms = rms
        self.isSilent = isSilent
        self.isVoiceActive = isVoiceActive
        self.timestamp = timestamp
    }
}