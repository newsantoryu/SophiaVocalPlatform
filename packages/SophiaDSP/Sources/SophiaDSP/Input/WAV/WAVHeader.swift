import Foundation

public struct WAVHeader {
    
    // MARK: - RIFF

    public let chunkID: String
    public let chunkSize: UInt32
    public let format: String

    // MARK: - FMT

    public let subchunk1ID: String
    public let subchunk1Size: UInt32
    public let audioFormat: UInt16
    public let numChannels: UInt16
    public let sampleRate: UInt32
    public let byteRate: UInt32
    public let blockAlign: UInt16
    public let bitsPerSample: UInt16

    // MARK: - DATA
    public let subchunk2ID: String
    public let subchunk2Size: UInt32    
}