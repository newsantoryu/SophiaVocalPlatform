import Foundation

public final class PitchStage: DSPStage {

    // MARK: - Dependencies

    private let yin: YINDetector

    // MARK: - Init

    public init(yin: YINDetector) {
        self.yin = yin
    }

    // MARK: - Processing

    public func process(
        _ frame: DSPFrame,
        sampleRate: Float
    ) -> DSPFrame {

        var updatedFrame = frame

        let frequency = yin.detect(
            buffer: frame.samples,
            sampleRate: sampleRate
        )

        updatedFrame.frequency = frequency
        updatedFrame.confidence = frequency != nil ? 1.0 : 0.0

        return updatedFrame
    }
}