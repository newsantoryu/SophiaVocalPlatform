import Testing
import Foundation
@testable import SophiaDSP

@Suite("DSP Stream Runtime Tests")
struct DSPStreamRuntimeTests {

    @Test("Engine should process buffers from provider")
    func testEngineRuntimeFlow() throws {

        let sampleRate: Float = 44100
        let expectedFrequency: Float = 440

        var buffer = [Float](
            repeating: 0,
            count: 4096
        )

        for i in 0..<buffer.count {
            let t = Float(i) / sampleRate

            buffer[i] = Float(
                sin(
                    2 * .pi * expectedFrequency * t
                )
            )
        }

        let provider = FakeBufferProvider(
            buffers: [buffer]
        )

        let pipeline = DSPPipeline(
            stages: [
                AmplitudeStage(),
                VoiceActivityStage(),
                PitchStage(
                    yin: YINDetector()
                )
            ]
        )

        let engine = DSPStreamEngine(
            provider: provider,
            pipeline: pipeline,
            sampleRate: sampleRate
        )

        var receivedPacket: DSPPacket?

        try engine.start { packet in
            receivedPacket = packet
        }

        #expect(receivedPacket != nil)

        guard let packet = receivedPacket else {
            Issue.record("No packet emitted")
            return
        }

        #expect(packet.frequency != nil)
        #expect(packet.isVoice == true)

        guard let detected = packet.frequency else {
            Issue.record("No frequency detected")
            return
        }

        let error = abs(
            detected - expectedFrequency
        )

        #expect(error < 1.0)
    }

    @Test("Engine should process silence correctly")
    func testEngineSilenceFlow() throws {

        let buffer = [Float](
            repeating: 0,
            count: 4096
        )

        let provider = FakeBufferProvider(
            buffers: [buffer]
        )

        let pipeline = DSPPipeline(
            stages: [
                AmplitudeStage(),
                VoiceActivityStage(),
                PitchStage(
                    yin: YINDetector()
                )
            ]
        )

        let engine = DSPStreamEngine(
            provider: provider,
            pipeline: pipeline,
            sampleRate: 44100
        )

        var receivedPacket: DSPPacket?

        try engine.start { packet in
            receivedPacket = packet
        }

        #expect(receivedPacket != nil)

        guard let packet = receivedPacket else {
            Issue.record("No packet emitted")
            return
        }

        #expect(packet.frequency == nil)
        #expect(packet.isVoice == false)
    }
}