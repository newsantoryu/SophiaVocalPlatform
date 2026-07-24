import Foundation 
import Testing
@testable import SophiaDSP

@Suite("WAV Source Tests")
struct WAVSourceTests { 

    @Test("Should expose metadata")
    func metadata() throws {
        let source = try WAVSource(path: "Samples/nct.wav")
        #expect(source.metadata.codec == .wav)
        #expect(source.metadata.channels > 0)
        #expect(source.metadata.sampleRate > 0)
        #expect(source.metadata.bitDepth > 0)
    }

    @Test("Should open source")
    func open() throws { 
        let source = try WAVSource(path: "Samples/nct.wav")
        try source.open()
        let data = try source.read()
        #expect(data != nil)
    }

    @Test("Should close source")
    func close() throws {
        let source = try WAVSource(path: "Samples/nct.wav")
        try  source.open()
        source.close()
        let data = try source.read()
        #expect(data == nil)
    }
    
}