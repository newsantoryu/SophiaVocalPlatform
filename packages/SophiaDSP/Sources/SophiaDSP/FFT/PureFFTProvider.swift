import Foundation

public final class PureFFTProvider: FFTProvider {

    public init(size: Int) {}

    public func performFFT(input: [Float]) -> [Float] {
        // fallback simples (placeholder)
        return input.map { abs($0) }
    }
}