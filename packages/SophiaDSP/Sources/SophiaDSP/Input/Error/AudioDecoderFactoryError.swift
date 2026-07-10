import Foundation

public enum AudioDecoderFactoryError: Error {

    case unsupportedBitDepth(Int)

    case unsupportedChannelCount(Int)

    case unsupportedEncoding(String)
}