import Foundation
import Testing
@testable import SophiaDSP

@Suite("WAV PCM Decoder Tests")
struct WAVPCMDecoderTests {

    @Test("Should convert PCM16 samples to Float")
    func decodePCM16Samples() throws {

        let data = createPCM16WAV()

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("wav")

        try data.write(to: url)

        defer {
            try? FileManager.default.removeItem(at: url)
        }

        let provider = try WAVFileProvider(
            path: url.path,
            bufferSize: 4
        )

        var received: [Float]?

        try provider.start { buffer in
            if received == nil {
                received = buffer
                provider.stop()
            }
        }

        guard let samples = received else {
            Issue.record("No samples returned")
            return
        }

        #expect(samples.count == 4)

        #expect(abs(samples[0] - 0.0) < 0.0001)
        #expect(abs(samples[1] - 1.0) < 0.0001)
        #expect(abs(samples[2] + 1.0) < 0.0001)
        #expect(abs(samples[3] - 0.5) < 0.0001)
    }
}

// MARK: - Helpers

private extension WAVPCMDecoderTests {

    func createPCM16WAV() -> Data {

        var bytes = [UInt8]()

        func appendString(_ value: String) {
            bytes.append(contentsOf: value.utf8)
        }

        func appendUInt16(_ value: UInt16) {
            var little = value.littleEndian
            withUnsafeBytes(of: &little) {
                bytes.append(contentsOf: $0)
            }
        }

        func appendInt16(_ value: Int16) {
            var little = value.littleEndian
            withUnsafeBytes(of: &little) {
                bytes.append(contentsOf: $0)
            }
        }

        func appendUInt32(_ value: UInt32) {
            var little = value.littleEndian
            withUnsafeBytes(of: &little) {
                bytes.append(contentsOf: $0)
            }
        }

        let samples: [Int16] = [
            0,
            Int16.max,
            Int16.min,
            Int16.max / 2
        ]

        let dataSize = UInt32(samples.count * 2)

        appendString("RIFF")
        appendUInt32(36 + dataSize)
        appendString("WAVE")

        appendString("fmt ")
        appendUInt32(16)
        appendUInt16(1)
        appendUInt16(1)
        appendUInt32(44_100)
        appendUInt32(44_100 * 2)
        appendUInt16(2)
        appendUInt16(16)

        appendString("data")
        appendUInt32(dataSize)

        samples.forEach(appendInt16)

        return Data(bytes)
    }
}