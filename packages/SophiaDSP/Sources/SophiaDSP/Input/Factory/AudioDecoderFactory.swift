import Foundation

public enum AudioDecoderFactory {

    public static func makeDecoder(
        format: PCMFormat
    ) throws -> PCMDecoder {

        switch format.bitDepth {

        case 16:
            return PCM16Decoder(
                format: format
            )

        case 24:
            throw AudioInputError.unsupportedBitDepth

        case 32:
            throw AudioInputError.unsupportedBitDepth

        default:
            throw AudioInputError.unsupportedBitDepth
        }
    }
}