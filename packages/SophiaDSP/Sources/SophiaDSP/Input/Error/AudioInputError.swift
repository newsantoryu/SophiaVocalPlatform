import Foundation

public enum AudioInputError: Error {

    case unsupportedBitDepth
    case unsupportedChannelConfiguration
    case unsupportedSampleRate

    case invalidFile
    case invalidHeader
    case corruptedData

    case unsupportedFormat
    case decoderNotFound

    case invalidAudioData
    
}