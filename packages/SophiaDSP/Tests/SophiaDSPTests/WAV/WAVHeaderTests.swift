import Foundation
import Testing
@testable import SophiaDSP

@Suite("WAV Header Tests")
struct WAVHeaderTests {

    @Test("Should parse valid WAV header")
    func parseValidHeader() throws {

        let data = createMinimalWAV()

        let riff = try RIFFParser().parse(from: data)

        let header = try WAVHeaderParser().parse(riff: riff)

        #expect(header.chunkID == "RIFF")
        #expect(header.format == "WAVE")
        #expect(header.audioFormat == 1)
        #expect(header.numChannels == 1)
        #expect(header.bitsPerSample == 16)
    }
}

// MARK: Helpers

private extension WAVHeaderTests {

    func createMinimalWAV() -> Data {

        var bytes: [UInt8] = []

        func appendString(_ value: String) {
            bytes.append(contentsOf: value.utf8)
        }

        func appendUInt16(_ value: UInt16) {
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

        appendString("RIFF")
        appendUInt32(36)
        appendString("WAVE")

        appendString("fmt ")
        appendUInt32(16)
        appendUInt16(1)
        appendUInt16(1)
        appendUInt32(44_100)
        appendUInt32(88_200)
        appendUInt16(2)
        appendUInt16(16)

        appendString("data")
        appendUInt32(0)

        return Data(bytes)
    }
}