import Foundation
@testable import SophiaDSP

class FakeAudioSource: AudioSource {
    var isOpen = false

    let metadata = AudioMetadata(
        sampleRate: 44100.0,
        channels: 2,
        bitDepth: 16,
        codec: .wav,
        duration: 10.0
    )


    func open() throws {
        isOpen = true
    }

    func read() throws -> Data? {
        guard isOpen else { return nil }
        return Data(repeating: 0, count: 8)
    }

    func close() {
        isOpen = false
    }
}