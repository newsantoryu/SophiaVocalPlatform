import Foundation

public protocol FFTProvider {
    func performFFT(input: [Float]) -> [Float]
}