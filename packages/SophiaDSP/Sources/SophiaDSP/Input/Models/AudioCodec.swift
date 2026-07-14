import Foundation

public enum AudioCodec:Equatable {
    case pcm16
    case pcm24
    case pcm32
    case float32

    case wav
    case mp3
    case aac
    case flac
    case opus

    case unknown
}