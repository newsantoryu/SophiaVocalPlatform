//
//  YINDetector.swift
//  Created by victor almeida on 04/05/26.
//

#if canImport(Accelerate)
import Accelerate
#endif
import Foundation

public final class YINDetector {

    // MARK: - Configuração

    public let bufferSize: Int
    public let threshold: Float
    public let minFrequency: Float
    public let maxFrequency: Float

    // MARK: - Init

    public init(
        bufferSize: Int = 4096,
        threshold: Float = 0.12,
        minFrequency: Float = 80,
        maxFrequency: Float = 1100
    ) {
        self.bufferSize = bufferSize
        self.threshold = threshold
        self.minFrequency = minFrequency
        self.maxFrequency = maxFrequency
    }

    // MARK: - API

    public func detect(buffer: [Float], sampleRate: Float) -> Float? {

        guard buffer.count >= bufferSize else { return nil }

        // ✔ versão estável (evita corte de fase)
        let slice: [Float]
        if buffer.count == bufferSize {
            slice = buffer
        } else {
            let start = max(0, buffer.count - bufferSize)
            slice = Array(buffer[start..<buffer.count])
        }

        let tauMin = Int(sampleRate / maxFrequency)
        let tauMax = Int(sampleRate / minFrequency)

        guard tauMax < bufferSize / 2 else { return nil }

        #if canImport(Accelerate)
        let cmndf = computeCMNDF(signal: slice, tauMax: tauMax)
        #else
        let cmndf = computeCMNDFPure(signal: slice, tauMax: tauMax)
        #endif

        guard let tau = absoluteThreshold(cmndf: cmndf, tauMin: tauMin, tauMax: tauMax) else {
            return nil
        }

        let refinedTau = parabolicInterpolation(cmndf: cmndf, tau: tau)

        return sampleRate / refinedTau
    }

    // MARK: - CMNDF (CORRETO)

    #if canImport(Accelerate)
    private func computeCMNDF(signal: [Float], tauMax: Int) -> [Float] {

        var diff = [Float](repeating: 0, count: tauMax + 1)

        // ✔ YIN correto: diferença direta (não autocorrelation fake)
        for tau in 1...tauMax {
            var sum: Float = 0

            for i in 0..<(signal.count - tau) {
                let d = signal[i] - signal[i + tau]
                sum += d * d
            }

            diff[tau] = sum
        }

        var cmndf = [Float](repeating: 0, count: tauMax + 1)
        cmndf[0] = 1

        var runningSum: Float = 0

        for tau in 1...tauMax {
            runningSum += diff[tau]

            guard runningSum > 1e-10 else {
                cmndf[tau] = 1
                continue
            }

            cmndf[tau] = diff[tau] / (runningSum / Float(tau))
        }

        return cmndf
    }
    #endif

    private func computeCMNDFPure(signal: [Float], tauMax: Int) -> [Float] {

        var diff = [Float](repeating: 0, count: tauMax + 1)

        for tau in 1...tauMax {
            var sum: Float = 0

            for i in 0..<(signal.count - tau) {
                let d = signal[i] - signal[i + tau]
                sum += d * d
            }

            diff[tau] = sum
        }

        var cmndf = [Float](repeating: 0, count: tauMax + 1)
        cmndf[0] = 1

        var runningSum: Float = 0

        for tau in 1...tauMax {
            runningSum += diff[tau]

            guard runningSum > 1e-10 else {
                cmndf[tau] = 1
                continue
            }

            cmndf[tau] = diff[tau] / (runningSum / Float(tau))
        }

        return cmndf
    }

    // MARK: - Threshold search

    private func absoluteThreshold(cmndf: [Float], tauMin: Int, tauMax: Int) -> Int? {

        var tau = tauMin

        while tau <= tauMax {
            if cmndf[tau] < threshold {

                var minTau = tau

                while tau + 1 <= tauMax && cmndf[tau + 1] < cmndf[tau] {
                    tau += 1
                    minTau = tau
                }

                return minTau
            }

            tau += 1
        }

        return nil
    }

    // MARK: - Parabolic interpolation

    private func parabolicInterpolation(cmndf: [Float], tau: Int) -> Float {

        guard tau > 0, tau < cmndf.count - 1 else {
            return Float(tau)
        }

        let s0 = cmndf[tau - 1]
        let s1 = cmndf[tau]
        let s2 = cmndf[tau + 1]

        let denom = s0 - 2 * s1 + s2

        guard abs(denom) > 1e-6 else {
            return Float(tau)
        }

        let offset = (s0 - s2) / (2 * denom)

        return Float(tau) + max(-1, min(1, offset))
    }
}