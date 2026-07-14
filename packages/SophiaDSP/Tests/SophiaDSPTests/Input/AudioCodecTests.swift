import Testing
@testable import SophiaDSP

@Suite("Audio Codec Tests")
struct AudioCodecTests {

    @Test("Should support equality")
    func equality()  {

        #expect(AudioCodec.pcm16 == .pcm16)
        #expect(AudioCodec.mp3 == .mp3)
        #expect(AudioCodec.wav == .wav)
    }

    @Test("Sould support unknown codec")
    func unkownCodec() {

        #expect(AudioCodec.unknown == .unknown)
    }

}