import Foundation

public enum WAVError: Error {

    case invalidRIFFHeader
    case invalidWAVEFormat

    case unsupportedAudioFormat
    case unsupportedBitDepth
    case unsupportedChannelConfiguration

    case invalidHeader
    case invalidDataChunk
}