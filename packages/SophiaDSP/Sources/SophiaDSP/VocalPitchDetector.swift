//
//  VocalPitchDetector.swift
//

#if canImport(Accelerate)
import Accelerate
#endif
import Foundation

public final class VocalPitchDetector {

    // MARK: - Dependências

    /// Detector YIN — primário
    public let yin: YINDetector

    /// FFT provider injetado (Apple/Linux)
    private let fft: FFTProvider

    private let estimator: FrequencyEstimator

    // MARK: - Configuração

    public let fftSize = 4096
    public let maxCrossValidationCents: Float = 50

    // MARK: - Init

    public init(fft: FFTProvider) {
        self.yin = YINDetector(
            bufferSize: fftSize,
            threshold: 0.12,
            minFrequency: 80,
            maxFrequency: 1100
        )

        self.fft = fft
        self.estimator = FrequencyEstimator()
    }

    // MARK: - API

    public func detect(
        buffer: [Float],
        sampleRate: Float,
        expectedRange: ClosedRange<Float>? = nil
    ) -> PitchResult? {

        guard buffer.count >= fftSize else { return nil }
        guard sampleRate > 0 else { return nil }

        // --- YIN (principal) ---
        let yinFrequency = yin.detect(buffer: buffer, sampleRate: sampleRate)

        // --- FFT (fallback) ---
        let fftFrequency = detectViaFFT(buffer: buffer, sampleRate: sampleRate)

        // --- decisão ---
        let frequency: Float

        switch (yinFrequency, fftFrequency) {

        case let (yin?, fft?):
            let centsDiff = abs(centsDistance(from: yin, to: fft))

            frequency = (centsDiff <= maxCrossValidationCents)
                ? yin
                : fft

        case let (yin?, nil):
            frequency = yin

        case let (nil, fft?):
            frequency = fft

        case (nil, nil):
            return nil
        }

        // --- correção de oitava ---
        var corrected = frequency

        if let range = expectedRange {
            while corrected < range.lowerBound { corrected *= 2 }
            while corrected > range.upperBound { corrected /= 2 }
        }

        return MusicTheory.analyze(frequency: corrected)
    }

    // MARK: - FFT Pipeline

    private func detectViaFFT(buffer: [Float], sampleRate: Float) -> Float? {

        let start = max(0, buffer.count / 2 - fftSize / 2)
        guard start + fftSize <= buffer.count else { return nil }

        var slice = Array(buffer[start..<start + fftSize])

        Windowing.applyHann(to: &slice)

        var magnitudes = fft.performFFT(input: slice)
        magnitudes = magnitudes.map { sqrt($0) }

        let hps = HarmonicProductSpectrum.apply(
            to: magnitudes,
            harmonics: 4
        )

        return estimator.estimate(
            magnitudes: hps,
            fftSize: fftSize,
            sampleRate: sampleRate
        )
    }

    // MARK: - Utils

    private func centsDistance(from a: Float, to b: Float) -> Float {
        guard a > 0, b > 0 else { return .infinity }
        return 1200 * log2(b / a)
    }
}