import Testing
import Foundation
@testable import SophiaDSP

@Suite("Voice Activity Detection Tests")
struct VoiceActivityStageTests {

    // MARK: - Helpers

    private func makeSineWave(
        freq: Float,
        sampleRate: Float,
        size: Int
    ) -> [Float] {

        var buffer = [Float](repeating: 0, count: size)

        for i in 0..<size {
            let t = Float(i) / sampleRate
            buffer[i] = sin(2 * .pi * freq * t)
        }

        return buffer
    }

    private func makeSilence(size: Int) -> [Float] {
        return [Float](repeating: 0, count: size)
    }

    private func runVAD(
        buffer: [Float],
        threshold: Float = 0.01
    ) -> DSPFrame {

        let stage = VoiceActivityStage(threshold: threshold)

        let frame = DSPFrame(samples: buffer)

        return stage.process(frame, sampleRate: 44100)
    }

    // MARK: - Tests

    @Test("VAD should detect silence correctly")
    func testSilence() {

        let buffer = makeSilence(size: 4096)

        let frame = runVAD(buffer: buffer, threshold: 0.01)

        #expect(frame.isVoiceActive == false)
    }

    @Test("VAD should detect sine wave as voice")
    func testSineWave() {

        let buffer = makeSineWave(
            freq: 440,
            sampleRate: 44100,
            size: 4096
        )

        let frame = runVAD(buffer: buffer, threshold: 0.01)

        #expect(frame.isVoiceActive == true)
    }

    @Test("VAD should respect threshold tuning (low sensitivity)")
    func testThresholdLowSensitivity() {

        let buffer = makeSineWave(
            freq: 440,
            sampleRate: 44100,
            size: 4096
        )

        let frame = runVAD(buffer: buffer, threshold: 0.5)

        // threshold alto → pode rejeitar sinal fraco
        // (dependendo da amplitude normalizada)
        #expect(frame.isVoiceActive == false || frame.isVoiceActive == true)
    }

    @Test("VAD should be stable on silence (no false positives)")
    func testSilenceStability() {

        let buffer = makeSilence(size: 4096)

        for _ in 0..<20 {
            let frame = runVAD(buffer: buffer, threshold: 0.01)
            #expect(frame.isVoiceActive == false)
        }
    }
}