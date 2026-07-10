import Testing
@testable import SophiaDSP

@Suite("Audio Decoder Factory Tests")
struct AudioDecoderFactoryTests {

    @Test("Should create PCM16 decoder")
    func createPCM16Decoder() throws {

        let format = PCMFormat(
            bitDepth: 16,
            sampleRate: 44_100,
            channels: 1
        )

        let decoder = try AudioDecoderFactory.makeDecoder(
            format: format
        )

        #expect(decoder is PCM16Decoder)
    }

    @Test("Should reject unsupported 24-bit PCM")
    func reject24BitPCM() {

        let format = PCMFormat(
            bitDepth: 24,
            sampleRate: 44_100,
            channels: 1
        )

        #expect(throws: AudioInputError.unsupportedBitDepth) {
            _ = try AudioDecoderFactory.makeDecoder(
                format: format
            )
        }
    }

    @Test("Should reject unsupported 32-bit PCM")
    func reject32BitPCM() {

        let format = PCMFormat(
            bitDepth: 32,
            sampleRate: 44_100,
            channels: 1
        )

        #expect(throws: AudioInputError.unsupportedBitDepth) {
            _ = try AudioDecoderFactory.makeDecoder(
                format: format
            )
        }
    }

    @Test("Should reject invalid bit depth")
    func rejectInvalidBitDepth() {

        let format = PCMFormat(
            bitDepth: 12,
            sampleRate: 44_100,
            channels: 1
        )

        #expect(throws: AudioInputError.unsupportedBitDepth) {
            _ = try AudioDecoderFactory.makeDecoder(
                format: format
            )
        }
    }
}