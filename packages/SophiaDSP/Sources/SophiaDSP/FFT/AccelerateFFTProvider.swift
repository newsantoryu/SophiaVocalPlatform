//
//  FFTProcessor.swift
//
//  Created by victor almeida on 05/05/26.
//

// Fluxo completo:
// Buffer PCM → Windowing (Hann) → FFT → magnitude → HPS → FrequencyEstimator
//           → correção de sub-harmônicos → MusicTheory.analyze → PitchResult
#if canImport(Accelerate)
import Accelerate
import Foundation

public final class AccelerateFFTProvider: FFTProvider {

    private let fftSetup: FFTSetup
    private let log2n: vDSP_Length
    public let fftSize: Int
    public let halfSize: Int

    public init(size: Int) {
        self.fftSize = size
        self.halfSize = size / 2
        self.log2n = vDSP_Length(log2(Double(size)).rounded(.down))

        guard let setup = vDSP_create_fftsetup(log2n, FFTRadix(kFFTRadix2)) else {
            fatalError("FFT setup failure")
        }

        self.fftSetup = setup
    }

    deinit {
        vDSP_destroy_fftsetup(fftSetup)
    }

    public func performFFT(input: [Float]) -> [Float] {
        var real = input
        var imag = [Float](repeating: 0, count: fftSize)

        real.withUnsafeMutableBufferPointer { realPtr in
            imag.withUnsafeMutableBufferPointer { imagPtr in

                var splitComplex = DSPSplitComplex(
                    realp: realPtr.baseAddress!,
                    imagp: imagPtr.baseAddress!
                )

                vDSP_fft_zip(
                    fftSetup,
                    &splitComplex,
                    1,
                    log2n,
                    FFTDirection(FFT_FORWARD)
                )

                var magnitudes = [Float](repeating: 0, count: halfSize)

                vDSP_zvmags(
                    &splitComplex,
                    1,
                    &magnitudes,
                    1,
                    vDSP_Length(halfSize)
                )

                return magnitudes
            }
        }

        return []
    }
}
#endif

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - HarmonicProductSpectrum
// ─────────────────────────────────────────────────────────────────────────────

public struct HarmonicProductSpectrum {

    static func apply(to magnitudes: [Float], harmonics: Int = 4) -> [Float] {
        var hps = magnitudes

        for h in 2...harmonics {
            for i in 0..<magnitudes.count {
                let harmonicIndex = i * h
                guard harmonicIndex < magnitudes.count else { break }
                hps[i] *= magnitudes[harmonicIndex]
            }
        }
        return hps
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - FrequencyEstimator
// ─────────────────────────────────────────────────────────────────────────────

/// Localiza o bin de maior magnitude dentro da faixa completa de vozes humanas.
///
/// CORREÇÃO: faixa anterior (120–400 Hz) cortava sopranos e mezzosopranos,
/// causando falhas no fallback FFT para referências femininas acima de 400 Hz.
/// Nova faixa (80–1100 Hz) cobre:
///   - Baixo profundo: ~80 Hz
///   - Soprano agudo:  ~1050 Hz
public final class FrequencyEstimator {

    // ✅ CORRIGIDO: era 120–400 Hz — não cobria vozes femininas agudas
    public let minFrequency: Float = 80
    public let maxFrequency: Float = 1100

   public func estimate(magnitudes: [Float], fftSize: Int, sampleRate: Float) -> Float? {

        guard !magnitudes.isEmpty else { return nil }

        let binResolution = sampleRate / Float(fftSize)
        let minIndex = max(1, Int(minFrequency / binResolution))
        let maxIndex = min(Int(maxFrequency / binResolution), magnitudes.count - 1)

        guard minIndex < maxIndex else { return nil }

        var maxMagnitude: Float = 0
        var peakIndex: Int = minIndex

        for i in minIndex...maxIndex {
            if magnitudes[i] > maxMagnitude {
                maxMagnitude = magnitudes[i]
                peakIndex = i
            }
        }

        guard maxMagnitude > 0 else { return nil }
        return Float(peakIndex) * binResolution
    }
}
