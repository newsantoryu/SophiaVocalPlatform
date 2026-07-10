import Foundation
import Testing
@testable import SophiaDSP

@Suite("WAV Decoder Tests")
struct WAVDecoderTests {

    @Test("Should decode valid PCM16 WAV")
    func decodePCM16WAV() throws {

        let header = WAVHeader(
            chunkID: "RIFF",
            chunkSize: 44,
            format: "WAVE",
            subchunk1ID: "fmt ",
            subchunk1Size: 16,
            audioFormat: 1,
            numChannels: 1,
            sampleRate: 44_100,
            byteRate: 88_200,
            blockAlign: 2,
            bitsPerSample: 16,
            subchunk2ID: "data",
            subchunk2Size: 8
        )

        let pcm = Data([
            0x00,0x00,
            0xFF,0x7F,
            0x00,0x80,
            0x00,0x40
        ])

        let decoder = try WAVDecoder(header: header)

        let samples = try decoder.decode(data: pcm)

        #expect(samples.count == 4)
        #expect(abs(samples[0]) < 0.0001)
        #expect(samples[1] > 0.99)
        #expect(samples[2] < -0.99)
        #expect(samples[3] > 0.49)
    }

    @Test("Should preserve sample rate")
    func preserveSampleRate() throws {

        let header = WAVHeader(
            chunkID: "RIFF",
            chunkSize: 44,
            format: "WAVE",
            subchunk1ID: "fmt ",
            subchunk1Size: 16,
            audioFormat: 1,
            numChannels: 1,
            sampleRate: 48_000,
            byteRate: 96_000,
            blockAlign: 2,
            bitsPerSample: 16,
            subchunk2ID: "data",
            subchunk2Size: 0
        )

        let decoder = try WAVDecoder(header: header)

        #expect(decoder.sampleRate == 48_000)
    }

    @Test("Should preserve channel count")
    func preserveChannels() throws {

        let header = WAVHeader(
            chunkID: "RIFF",
            chunkSize: 44,
            format: "WAVE",
            subchunk1ID: "fmt ",
            subchunk1Size: 16,
            audioFormat: 1,
            numChannels: 2,
            sampleRate: 44_100,
            byteRate: 176_400,
            blockAlign: 4,
            bitsPerSample: 16,
            subchunk2ID: "data",
            subchunk2Size: 0
        )

        let decoder = try WAVDecoder(header: header)

        #expect(decoder.channels == 2)
    }

    @Test("Should reject unsupported PCM")
    func rejectUnsupportedPCM() {

        let header = WAVHeader(
            chunkID: "RIFF",
            chunkSize: 44,
            format: "WAVE",
            subchunk1ID: "fmt ",
            subchunk1Size: 16,
            audioFormat: 1,
            numChannels: 1,
            sampleRate: 44_100,
            byteRate: 132_300,
            blockAlign: 3,
            bitsPerSample: 24,
            subchunk2ID: "data",
            subchunk2Size: 0
        )

        #expect(throws: AudioInputError.unsupportedBitDepth) {
            _ = try WAVDecoder(header: header)
        }
    }
}