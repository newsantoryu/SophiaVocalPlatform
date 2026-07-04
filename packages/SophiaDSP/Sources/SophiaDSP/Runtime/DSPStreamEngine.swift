import Foundation

public final class DSPStreamEngine {

    private let provider: AudioBufferProvider
    private let pipeline: DSPPipeline
    private let sampleRate: Float

    public init(
        provider: AudioBufferProvider,
        pipeline: DSPPipeline,
        sampleRate: Float
    ) {
        self.provider = provider
        self.pipeline = pipeline
        self.sampleRate = sampleRate
    }

    public func start(
        onPacket: @escaping (DSPPacket) -> Void
    ) throws {

        try provider.start { [weak self] buffer in
            guard let self else { return }

            let frame = self.pipeline.process(
                buffer: buffer,
                sampleRate: self.sampleRate
            )

            let packet = DSPPacket(
                frequency: frame.frequency,
                rms: frame.rms ?? 0,
                isVoice: frame.isVoiceActive,
                confidence: frame.confidence ?? 0,
                timestamp: frame.timestamp
            )

            onPacket(packet)
        }
    }

    public func stop() {
        provider.stop()
    }
}