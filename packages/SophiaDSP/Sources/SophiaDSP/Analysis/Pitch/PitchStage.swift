import Foundation

public final class PitchStage: DSPStage {

    // MARK: - Properties

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

        // Evita processamento desnecessário
        // Não roda pitch detection em silêncio
        // nem quando não há atividade vocal detectada
        guard !frame.isSilent,
              frame.isVoiceActive else {

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