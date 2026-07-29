import Foundation

public struct WAVFile {

    public let riff: RIFFFile

    public let format: WAVFormatChunk

    public let data: DATAChunk

    public let list: LISTChunk?

    public let fact: FACTChunk?

    public let cue: CUEChunk?

    public let smpl: SMPLChunk?

    public let bext: BEXTChunk?

    public init(
        riff: RIFFFile,
        format: WAVFormatChunk,
        data: DATAChunk,
        list: LISTChunk? = nil,
        fact: FACTChunk? = nil,
        cue: CUEChunk? = nil,
        smpl: SMPLChunk? = nil,
        bext: BEXTChunk? = nil
    ) {

        self.riff = riff
        self.format = format
        self.data = data

        self.list = list
        self.fact = fact
        self.cue = cue
        self.smpl = smpl
        self.bext = bext
    }
}