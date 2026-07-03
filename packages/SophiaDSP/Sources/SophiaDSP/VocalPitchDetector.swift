//
//  VocalPitchDetector.swift
//

public final class VocalPitchDetector {

    private let pipeline: DSPPipeline
    private let estimator: FrequencyEstimator

    public init(pipeline: DSPPipeline) {
        self.pipeline = pipeline
        self.estimator = FrequencyEstimator()
    }

    public func detect(buffer: [Float], sampleRate: Float) -> PitchResult? {

        let output = pipeline.process(
            buffer: buffer,
             sampleRate: sampleRate
            )

    guard let freq = output.frequency else {
            return nil
            }

        return MusicTheory.analyze(frequency: freq)
    }
}