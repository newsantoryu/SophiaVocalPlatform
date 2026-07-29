import Foundation

public struct DATAChunk {
    
    public let pcmData:Data

    public init(pcmData: Data) {
        self.pcmData = pcmData
    }
}