import Foundation
import Testing
@testable import SophiaDSP

@Suite("WAV File Provider Tests")
struct WAVFileProviderTests {

    @Test("Should load a valid WAV file")
    func loadValidFile() throws {

        let data = createMinimalWAV()

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("wav")

        try data.write(to: url)

        defer {
            try? FileManager.default.removeItem(at: url)
        }

        let provider = try WAVFileProvider(path: url.path)

        #expect(provider.header.audioFormat == 1)
        #expect(provider.header.sampleRate == 44_100)
        #expect(provider.header.numChannels == 1)
    }
}

// MARK: - Helpers

private extension WAVFileProviderTests {

    func createMinimalWAV() -> Data {

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

        func appendUInt32(_ value: UInt32) {
            var little = value.littleEndian
            withUnsafeBytes(of: &little) {
                bytes.append(contentsOf: $0)
            }
        }

        // RIFF

        appendString("RIFF")
        appendUInt32(36)
        appendString("WAVE")

        // fmt

        appendString("fmt ")
        appendUInt32(16)
        appendUInt16(1)       // PCM
        appendUInt16(1)       // Mono
        appendUInt32(44_100)
        appendUInt32(88_200)
        appendUInt16(2)
        appendUInt16(16)

        // data

        appendString("data")
        appendUInt32(0)

        return Data(bytes)
    }
}