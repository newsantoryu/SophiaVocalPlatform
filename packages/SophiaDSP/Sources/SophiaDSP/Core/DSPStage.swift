import Foundation

public protocol DSPStage {
    func process(_ frame: DSPFrame, sampleRate: Float) -> DSPFrame
}
