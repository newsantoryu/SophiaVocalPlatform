import Foundation
import Testing
@testable import SophiaDSP

@Suite("USB Audio Provider Tests")
struct USBAudioProviderTests {

    @Test("Should decode one PCM16 sample")
    func decodeOneSample() throws {

        let pcm = Data([
            0x00,
            0x00
        ])

        let transport = MockTransport(
            packets: [pcm]
        )

       let provider = USBAudioProvider(
    transport: transport,
    format: PCMFormat(
        bitDepth: 16,
        sampleRate: 16_000,
        channels: 1
    )
)
        var received: [Float] = []

        try provider.start { samples in

            received.append(contentsOf: samples)

            provider.stop()
        }

        #expect(received.count == 1)
        #expect(received.first == 0)
    }

    @Test("Should ignore empty packets")
    func ignoreEmptyPackets() throws {

        let transport = MockTransport(
            packets: [
                Data()
            ]
        )

        let provider = USBAudioProvider(
            transport: transport,
            format: PCMFormat(
                bitDepth: 16,
                sampleRate: 16_000,
                channels: 1
            )
        )

        var called = false

        try provider.start { _ in

            called = true

            provider.stop()
        }

        #expect(called == false)
    }
}