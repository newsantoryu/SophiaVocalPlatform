import Foundation

public struct DSPFrame {

    public var samples: [Float]

    public var detectedFrequency: Float?

    public var confidence: Float?

    public var harmonics: [Float]

    public init(samples: [Float]) {
        self.samples = samples
        self.harmonics = []
    }
}