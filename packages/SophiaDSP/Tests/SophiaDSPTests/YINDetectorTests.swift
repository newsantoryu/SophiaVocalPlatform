import Testing
import Foundation
@testable import SophiaDSP

@Suite("Validação de Algoritimos de Áudio")
struct YINDetectorTests {

    @Test("Detecção de frequência controlada")
    func testYINAccuracy() {

        let sampleRate: Float = 44100.0
        let frequencyToDetect: Float = 440.0
        let bufferSize = 4096

        let detector = YINDetector(bufferSize: bufferSize)

        var mockBuffer = [Float](repeating: 0, count: bufferSize)

        for i in 0..<bufferSize {
            let t = Float(i) / sampleRate
            mockBuffer[i] = sin(2.0 * Float.pi * frequencyToDetect * t)
        }

        let result = detector.detect(buffer: mockBuffer, sampleRate: sampleRate)

        #expect(result != nil)

        if let detected = result {
            let error = abs(detected - frequencyToDetect)
            #expect(error < 0.5)
        }
    }
}
