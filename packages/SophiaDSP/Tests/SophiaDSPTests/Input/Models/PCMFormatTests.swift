import Testing
@testable import SophiaDSP

@Suite("PCM Format Tests")
struct PCMFormatTests {

    @Test("Should calculate bytes per sample")
    func bytesPerSample() {

        let format = PCMFormat(
            bitDepth: 16,
            sampleRate: 44100,
            channels: 1
        )

        #expect(format.bytesPerSample == 2)
    }

    @Test("Should identify mono format")
    func monoFormat() {

        let format = PCMFormat(
            bitDepth: 16,
            sampleRate: 44100,
            channels: 1
        )

        #expect(format.isMono)
        #expect(!format.isStereo)
    }

    @Test("Should identify stereo format")
    func stereoFormat() {

        let format = PCMFormat(
            bitDepth: 24,
            sampleRate: 48000,
            channels: 2
        )

        #expect(format.isStereo)
        #expect(!format.isMono)
    }

    @Test("Should support equality")
    func equality() {

        let first = PCMFormat(
            bitDepth: 16,
            sampleRate: 44100,
            channels: 1
        )

        let second = PCMFormat(
            bitDepth: 16,
            sampleRate: 44100,
            channels: 1
        )

        #expect(first == second)
    }
}