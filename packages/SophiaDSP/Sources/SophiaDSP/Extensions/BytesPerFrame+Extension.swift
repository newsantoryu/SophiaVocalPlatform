import Foundation

public extension WAVFormatChunk {

    var bytesPerSample: Int {
        Int(bitsPerSample / 8)
    }

    var bytesPerFrame: Int {
        Int(blockAlign)
    }

}