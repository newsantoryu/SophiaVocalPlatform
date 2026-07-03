import Foundation
public struct VoiceActivityStage: DSPStage {

    public var threshold: Float

    public init(threshold: Float = 0.02) {
        self.threshold = threshold
    }

    public func process(_ frame: DSPFrame, sampleRate: Float) -> DSPFrame {

        var updated = frame

        let rms = computeRMS(frame.samples)
        updated.rms = rms

        let isVoice = rms > threshold

        updated.isSilent = !isVoice
        updated.isVoiceActive = isVoice   // 👈 ESSENCIAL

        return updated
    }

    private func computeRMS(_ samples: [Float]) -> Float {
        guard !samples.isEmpty else { return 0 }

        var sum: Float = 0
        for s in samples {
            sum += s * s
        }
        return sqrt(sum / Float(samples.count))
    }
}