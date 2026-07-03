import Foundation

public struct DSPFrame {

    // MARK: - Raw Audio

    public var samples: [Float]

    // MARK: - Analysis

    public var frequency: Float?
    public var confidence: Float?
    public var amplitude: Float?

    // MARK: - Metadata

    public var timestamp: TimeInterval

    // MARK: - Init

    public init(
        samples: [Float],
        frequency: Float? = nil,
        confidence: Float? = nil,
        amplitude: Float? = nil,
        timestamp: TimeInterval = Date().timeIntervalSince1970
    ) {
        self.samples = samples
        self.frequency = frequency
        self.confidence = confidence
        self.amplitude = amplitude
        self.timestamp = timestamp
    }
}