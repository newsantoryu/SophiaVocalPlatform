import Foundation
import SophiaDSP

enum WAVTestFactory {

   static func pcm16(
    pcm: Data = Data(),
    channels: UInt16 = 1,
    sampleRate: UInt32 = 44_100,
     bitDepth: UInt16 = 16
) -> WAVFile {

    let format = WAVFormatChunk(
        audioFormat: 1,
        numChannels: channels,
        sampleRate: sampleRate,
        byteRate: sampleRate * UInt32(channels) * 2,
        blockAlign: channels * 2,
        bitsPerSample: 16
    )

    let riff = RIFFFile(
        chunkID: "RIFF",
        chunkSize: UInt32(36 + pcm.count),
        format: "WAVE",
        chunks: WAVChunkCollection(chunks: [])
    )

    let data = DATAChunk(
        pcmData: pcm
    )

    return WAVFile(
        riff: riff,
        format: format,
        data: data
    )
}
}