import Foundation
import Testing
@testable import SophiaDSP

@Suite("Audio Decoder Protocol Tests")
struct AudioDecoderTests {

    private final class FakeDecoder: AudioDecoder {

        let sampleRate: Float = 44100

        let channels = 1

        let duration: TimeInterval = 2.0

        private var consumed = false

        func readSamples(
            count: Int
        ) throws -> [Float]? {

            guard !consumed else {
                return nil
            }

            consumed = true

            return Array(
                repeating: 0.5,
                count: count
            )
        }

        func seek(
            to time: TimeInterval
        ) throws {

        }

        func close() {

        }
    }

    @Test("Decoder should provide samples")

    func decoderReadsSamples() throws {

        let decoder = FakeDecoder()

        let samples = try decoder.readSamples(
            count: 256
        )

        #expect(samples != nil)
        #expect(samples?.count == 256)
    }

    @Test("Decoder should finish stream")

    func decoderEndsStream() throws {

        let decoder = FakeDecoder()

        _ = try decoder.readSamples(count: 10)

        let second = try decoder.readSamples(count: 10)

        #expect(second == nil)
    }

    @Test("Decoder exposes metadata")

    func decoderMetadata() {

        let decoder = FakeDecoder()

        #expect(decoder.sampleRate == 44100)
        #expect(decoder.channels == 1)
        #expect(decoder.duration == 2.0)
    }
}