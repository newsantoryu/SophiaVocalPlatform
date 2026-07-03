import Testing
import Foundation
@testable import SophiaDSP

@Suite("DSP Pipeline Tests")
struct DSPPipelineTests {

    @Test("PitchStage should extract frequency")
    func testPitchStage() {

        let yin = YINDetector()

        let stage = PitchStage(yin: yin)

        let pipeline = DSPPipeline(
            stages: [
                AmplitudeStage(),
                stage
            ]
        )

        let sampleRate: Float = 44100
        let expectedFrequency: Float = 440

        var buffer = [Float](repeating: 0, count: 4096)

        for i in 0..<buffer.count {
            let t = Float(i) / sampleRate
            buffer[i] = sin(2 * .pi * expectedFrequency * t)
        }

        let frame = pipeline.process(
            buffer: buffer,
            sampleRate: sampleRate
        )

        #expect(frame.frequency != nil)

        guard let detected = frame.frequency else {
            Issue.record("No frequency detected")
            return
        }

        let error = abs(detected - expectedFrequency)

        #expect(error < 1.0)
    }

    @Test("AmplitudeStage should detect silence")
    func testSilenceDetection() {

        let stage = AmplitudeStage()

        let silentBuffer = [Float](
            repeating: 0,
            count: 4096
        )

        let frame = DSPFrame(samples: silentBuffer)

        let processed = stage.process(
            frame,
            sampleRate: 44100
        )

        #expect(processed.isSilent == true)

        #expect(processed.rms != nil)

        guard let rms = processed.rms else {
            Issue.record("RMS not computed")
            return
        }

        #expect(rms < 0.001)
    }

@Test("PitchStage should ignore silent buffers")
func testPitchStageIgnoresSilence() {

    let yin = YINDetector()

    let pipeline = DSPPipeline(
        stages: [
            AmplitudeStage(),
            PitchStage(yin: yin)
        ]
    )

    let silentBuffer = [Float](
        repeating: 0,
        count: 4096
    )

    let frame = pipeline.process(
        buffer: silentBuffer,
        sampleRate: 44100
    )

    #expect(frame.isSilent == true)
    #expect(frame.frequency == nil)
    #expect(frame.confidence == 0)
}
}