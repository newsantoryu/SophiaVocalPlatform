import Testing
@testable import SophiaDSP

@Suite("Audio Metadata Tests")
struct AudioMetadataTests {

    @Test("Should preserve metadata values")
    func metadata() {

        let metadata = AudioMetadata(
            sampleRate: 44100.0, 
            channels: 2, 
            bitDepth: 16, 
            codec: .wav,
            duration: 120.0
        )
        #expect(metadata.sampleRate == 44100.0)
        #expect(metadata.channels == 2)
        #expect(metadata.bitDepth == 16)
        #expect(metadata.codec == .wav)
        #expect(metadata.duration == 120.0)
    }

}