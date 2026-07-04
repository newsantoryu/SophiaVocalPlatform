import Testing
import Foundation
@testable import SophiaDSP

@Suite("DSP Stream Engine Tests")
struct DSPStreamEngineTests {

    @Test("Engine should generate DSPPacket with frequency")
    func testEngineDetectsFrequency() {

        let pipeline = DSPPipeline(
            stages: [
                AmplitudeStage(),
                VoiceActivityStage(),
                PitchStage(yin: YINDetector())
            ]
        )

        let engine = DSPStreamEngine(
            pipeline: pipeline
        )

        let sampleRate: Float = 44100
        let expectedFrequency: Float = 440

        var buffer = [Float](repeating: 0, count: 4096)

        for i in 0..<buffer.count {
            let t = Float(i) / sampleRate
            buffer[i] = sin(2 * .pi * expectedFrequency * t)
        }

     let packet = engine.process(
    samples: buffer
)

        #expect(packet.frequency != nil)
        #expect(packet.isVoice == true)

        guard let detected = packet.frequency else {
            Issue.record("No frequency detected")
            return
        }

        let error = abs(detected - expectedFrequency)

        #expect(error < 1.0)
    }

    @Test("Engine should detect silence")
    func testEngineDetectsSilence() {

        let pipeline = DSPPipeline(
            stages: [
                AmplitudeStage(),
                PitchStage(yin: YINDetector()),
                VoiceActivityStage()
            ]
        )

        let engine = DSPStreamEngine(
            pipeline: pipeline
        )

        let buffer = [Float](repeating: 0, count: 4096)
let packet = engine.process(
    samples: buffer
)

        #expect(packet.isVoice == false)
        #expect(packet.frequency == nil)
        #expect(packet.rms < 0.001)
    }
}