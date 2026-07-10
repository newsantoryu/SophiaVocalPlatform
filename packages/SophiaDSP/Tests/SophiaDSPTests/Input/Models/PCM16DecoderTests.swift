import Testing
import Foundation
@testable import SophiaDSP

@Suite("PCM16 Decoder Tests")
struct PCM16DecoderTests {

    @Test("Should decode four PCM16 samples")
    func decodeSamples() throws {

        let format = PCMFormat(
            bitDepth: 16,
            sampleRate: 44100,
            channels: 1
        )

        let decoder = PCM16Decoder(
            format: format
        )

        let values: [Int16] = [
            Int16.min,
            -16384,
            0,
            Int16.max
        ]

        let data = values.withUnsafeBytes {
            Data($0)
        }

        let samples = try decoder.decode(data)

        #expect(samples.count == 4)

        #expect(abs(samples[0] + 1.0) < 0.001)
        #expect(abs(samples[1] + 0.5) < 0.01)
        #expect(abs(samples[2]) < 0.001)
        #expect(abs(samples[3] - 1.0) < 0.001)
    }

    @Test("Should decode empty data")
    func emptyBuffer() throws {

        let decoder = PCM16Decoder(
            format: PCMFormat(
                bitDepth: 16,
                sampleRate: 44100,
                channels: 1
            )
        )

        let samples = try decoder.decode(
            Data()
        )

        #expect(samples.isEmpty)
    }

    @Test("Should preserve sample count")
    func sampleCount() throws {

        let format = PCMFormat(
            bitDepth: 16,
            sampleRate: 44100,
            channels: 1
        )

        let decoder = PCM16Decoder(
            format: format
        )

        let values = Array(
            repeating: Int16(1000),
            count: 1024
        )

        let data = values.withUnsafeBytes {
            Data($0)
        }

        let samples = try decoder.decode(data)

        #expect(samples.count == 1024)
    }
}