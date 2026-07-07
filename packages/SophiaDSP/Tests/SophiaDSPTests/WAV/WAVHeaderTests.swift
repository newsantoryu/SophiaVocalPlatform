import Testing
import Foundation
@testable import SophiaDSP

@Suite("WAV Header Tests")
struct WAVHeaderTests {

    @Test("Parser should decode a valid WAV header")
    func parseValidHeader() throws {

        var bytes = [UInt8](repeating: 0, count: 44)

        bytes[0] = 82   // R
        bytes[1] = 73   // I
        bytes[2] = 70   // F
        bytes[3] = 70   // F

        bytes[8] = 87   // W
        bytes[9] = 65   // A
        bytes[10] = 86  // V
        bytes[11] = 69  // E

        bytes[12] = 102 // f
        bytes[13] = 109 // m
        bytes[14] = 116 // t
        bytes[15] = 32

        let data = Data(bytes)

        let header = try WAVFileProvider.parseHeader(from: data)

        #expect(header.chunkID == "RIFF")
        #expect(header.format == "WAVE")
    }
}