import Foundation

public final class DSPStreamEngine {

    // MARK: - Properties

    private let pipeline: DSPPipeline
    private let sampleRate: Float

    // MARK: - Init

    public init(
        sampleRate: Float = 44_100,
        pipeline: DSPPipeline
    ) {
        self.sampleRate = sampleRate
        self.pipeline = pipeline
    }

    public convenience init(
        sampleRate: Float = 44_100,
        stages: [DSPStage]
    ) {

        let pipeline = DSPPipeline(
            stages: stages
        )

        self.init(
            sampleRate: sampleRate,
            pipeline: pipeline
        )
    }

    public convenience init(
        sampleRate: Float = 44_100
    ) {

        let pipeline = DSPPipeline(
            stages: [
                AmplitudeStage(),
                VoiceActivityStage(),
                PitchStage(
                    yin: YINDetector()
                )
            ]
        )

        self.init(
            sampleRate: sampleRate,
            pipeline: pipeline
        )
    }

    // MARK: - Processing

    public func process(
        samples: [Float]
    ) -> DSPPacket {

        let frame = pipeline.process(
            buffer: samples,
            sampleRate: sampleRate
        )

        return DSPPacket(
            frequency: frame.frequency,
            rms: frame.rms ?? 0,
            isVoice: frame.isVoiceActive,
            confidence: frame.confidence ?? 0,
            timestamp: frame.timestamp
        )
    }
}