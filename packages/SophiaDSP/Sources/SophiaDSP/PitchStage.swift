import Foundation

public final class PitchStage: DSPStage {

    private let yin: YINDetector

    public init(yin: YINDetector) {
        self.yin = yin
    }

    public func process(
        _ frame: DSPFrame,
        sampleRate: Float
    ) -> DSPFrame {

        var updatedFrame = frame

        // Evita processamento desnecessário
        if frame.isSilent {
            updatedFrame.frequency = nil
            updatedFrame.confidence = 0
            return updatedFrame
        }

        let frequency = yin.detect(
            buffer: frame.samples,
            sampleRate: sampleRate
        )

        updatedFrame.frequency = frequency
        updatedFrame.confidence = frequency != nil ? 1.0 : 0.0

        return updatedFrame
    }
}