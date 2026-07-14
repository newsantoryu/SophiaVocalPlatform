import Testing
@testable import SophiaDSP

@Suite("Audio Source Protocol Tests")
struct AudioSourceTests {


    @Test("Source exposes metadata")
    func metadata() {

        let source = FakeAudioSource()
        #expect(source.metadata.sampleRate == 44100.0)
        #expect(source.metadata.channels == 2)
        #expect(source.metadata.bitDepth == 16)
       
    }

    @Test("Source opens correctly")
    func open() throws {
        let source = FakeAudioSource()
        try source.open()
        #expect(source.isOpen)
    }

    @Test("Source reads data")
    func read() throws {
        let source = FakeAudioSource()
        try source.open()
        let data = try source.read()
        #expect(data != nil)
        #expect(data?.count == 8)
    }   

    @Test("Source closes correctly")
    func close() throws {
        let source = FakeAudioSource()
        try source.open()
        source.close()
        #expect(!source.isOpen)
    }
}
