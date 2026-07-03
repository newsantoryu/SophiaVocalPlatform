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

        let frequency = yin.detect(
            buffer: frame.samples,
            sampleRate: sampleRate
        )

        updatedFrame.detectedFrequency = frequency

        return updatedFrame
    }
}