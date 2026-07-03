import Foundation

public final class AmplitudeStage: DSPStage {

    private let silenceThreshold: Float

    public init(
        silenceThreshold: Float = 0.01
    ) {
        self.silenceThreshold = silenceThreshold
    }

    public func process(
        _ frame: DSPFrame,
        sampleRate: Float
    ) -> DSPFrame {

        var updatedFrame = frame

        let rms = computeRMS(frame.samples)

        updatedFrame.rms = rms
        updatedFrame.isSilent = rms < silenceThreshold

        return updatedFrame
    }

    private func computeRMS(_ samples: [Float]) -> Float {

        guard !samples.isEmpty else {
            return 0
        }

        let energy = samples.reduce(Float(0)) {
            $0 + ($1 * $1)
        }

        return sqrt(energy / Float(samples.count))
    }
}