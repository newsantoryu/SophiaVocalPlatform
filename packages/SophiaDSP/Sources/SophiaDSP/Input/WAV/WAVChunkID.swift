import Foundation

public enum WAVChunkID: String {
    case riff = "RIFF"
    case wave = "WAVE"
    case fmt = "fmt "
    case data = "data"
    case list = "LIST"
    case junk = "JUNK"
    case fact = "fact"
    case bext = "bext"
    case cue = "cue"
    case smpl = "smpl"
    case unknown
}