import Foundation
import SophiaDSP

public final class AnalyzeCommand {

    public init() {}

    public func run(
        file path: String
    ) throws {

        // Audio Provider
        let provider = try WAVFileProvider(
            path: path
        )

        // DSP Pipeline
        let pipeline = DSPPipeline(
            stages: [
                AmplitudeStage(),
                VoiceActivityStage(),
                PitchStage(
                    yin: YINDetector()
                )
            ]
        )

        // Engine
        let engine = DSPStreamEngine(
            provider: provider,
            pipeline: pipeline,
            sampleRate: Float(provider.header.sampleRate)
        )

        // Runtime
        let runtime = ConsoleRuntime(
            engine: engine
        )

        try runtime.start()
    }
}