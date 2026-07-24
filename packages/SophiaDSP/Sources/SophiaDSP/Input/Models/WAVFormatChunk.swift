import Foundation

public struct WAVFormatChunk: Equatable {

    // MARK: - Format

    public let audioFormat: UInt16
    public let numChannels: UInt16
    public let sampleRate: UInt32
    public let byteRate: UInt32
    public let blockAlign: UInt16
    public let bitsPerSample: UInt16

    //Bytes extras of fmt (WAVE_FORMAT_EXTENSIBLE, ADPCM, etc)
    public let extraData: Data?

    // MARK: - Initializers

    public init(
        audioFormat: UInt16,
        numChannels: UInt16,
        sampleRate: UInt32,
        byteRate: UInt32,
        blockAlign: UInt16,
        bitsPerSample: UInt16,
        extraData: Data? = nil
    ) {
        self.audioFormat = audioFormat
        self.numChannels = numChannels
        self.sampleRate = sampleRate
        self.byteRate = byteRate
        self.blockAlign = blockAlign
        self.bitsPerSample = bitsPerSample
        self.extraData = extraData
    }
}