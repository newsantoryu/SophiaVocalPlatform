import Testing
import Foundation
@testable import SophiaDSP

@Suite("DSP Pipeline Tests")
struct DSPPipelineTests {

    @Test("PitchStage should extract frequency")
    func testPitchStage() {

        let yin = YINDetector()
        let stage = PitchStage(yin: yin)
        let pipeline = DSPPipeline(stages: [stage])

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
}
