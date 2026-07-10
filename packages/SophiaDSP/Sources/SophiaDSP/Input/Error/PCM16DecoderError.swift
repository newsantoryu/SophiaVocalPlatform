import Foundation

public enum PCM16DecoderError: Error {

    case invalidByteCount

    case unsupportedBitDepth

}