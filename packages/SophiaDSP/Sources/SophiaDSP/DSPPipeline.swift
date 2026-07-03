import Foundation

public protocol DSPStage {
    func process(_ frame: DSPFrame, sampleRate: Float) -> DSPFrame
}

public final class DSPPipeline {

    private let stages: [DSPStage]

    public init(stages: [DSPStage]) {
        self.stages = stages
    }

    public func process(
        buffer: [Float],
        sampleRate: Float
    ) -> DSPFrame {

        let initialFrame = DSPFrame(samples: buffer)

        return stages.reduce(initialFrame) { frame, stage in
            stage.process(frame, sampleRate: sampleRate)
        }
    }
}