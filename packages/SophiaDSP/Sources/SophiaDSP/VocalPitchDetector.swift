///// YIN-based pitch detection algorithm.
///
/// This detector estimates the fundamental frequency of a mono audio signal.
///
/// - Requirements:
///   - Input must be mono PCM (Float)
///   - Samples should be normalized between -1.0 and 1.0
///   - Buffer size should be at least 2048 samples
///
/// - Behavior:
///   - Returns nil for silence or low-confidence signals
///   - More accurate with harmonic-rich signals (e.g. voice, instruments)
///
/// - Performance:
///   - Designed for real-time usage
///   - Avoid using very small buffers (<1024)

//  Created by victor almeida on 05/05/26.
//

#if canImport(Accelerate)
    import Accelerate
#endif
import Foundation

#if canImport(Accelerate)
public final class VocalPitchDetector {

    // MARK: - Dependências

    /// Detector YIN — primário, alta precisão
    public let yin: YINDetector

    /// FFT para fallback e validação cruzada
    public  let fftSize = 4096
    private let fftProcessor: FFTProcessor
    private let estimator: FrequencyEstimator

    // MARK: - Configuração

    /// Diferença máxima em cents entre YIN e FFT para aceitar YIN como válido.
    public let maxCrossValidationCents: Float = 50

    // MARK: - Init
    /// Se divergirem mais que isso, usa FFT (mais conservador).

/* let minFreq: Float = 50
let maxFreq: Float = 1000
*/
    public init() {
        self.yin = YINDetector(
            bufferSize: 4096,
            threshold: 0.12,
            minFrequency: 80,   // Cobre vozes masculinas graves (baixo: ~80Hz)
            maxFrequency: 1100  // Cobre vozes femininas agudas (soprano: ~1050Hz)
        )
        self.fftProcessor = FFTProcessor(size: fftSize)
        self.estimator = FrequencyEstimator()
    }

  /// 
  /// Detects pitch from an audio buffer.
///
/// - Parameters:
///   - buffer: Audio samples (mono)
///   - sampleRate: Sampling rate (e.g. 44100 Hz)
///
/// - Returns:
///   - Frequency in Hz if detected
///   - Nil if detection fails or confidence is low
/// 
     public func detect(
        buffer: [Float],
        sampleRate: Float,
        expectedRange: ClosedRange<Float>? = nil
    ) -> PitchResult? {
        guard buffer.count >= fftSize else {
    return nil
}

guard sampleRate > 0 else {
    return nil
}

        // --- Caminho 1: YIN (primário) ---
        let yinFrequency = yin.detect(buffer: buffer, sampleRate: sampleRate)
        // --- Caminho 2: FFT+HPS (fallback / validação) ---
        let fftFrequency = detectViaFFT(buffer: buffer, sampleRate: sampleRate)

        // --- Seleção da melhor estimativa ---
        var frequency: Float

        switch (yinFrequency, fftFrequency) {

        case let (yin?, fft?):
            // Ambos detectaram — valida por cross-validation
            let centsDiff = abs(centsDistance(from: yin, to: fft))
            if centsDiff <= maxCrossValidationCents {
                // Concordam — usa YIN (mais preciso)
                frequency = yin
            } else {
                // Divergem muito — usa FFT (mais conservador para vozes harmônicas)
                frequency = fft
            }

        case let (yin?, nil):
            // Só YIN detectou — confia no YIN
            frequency = yin

        case let (nil, fft?):
            // YIN falhou — usa FFT como fallback
            frequency = fft

        case (nil, nil):
            // Nenhum detectou — sinal sem pitch (silêncio, ruído, consoante)
            return nil
        }

        // --- Correção de oitava ---
        // HPS e YIN podem detectar sub-harmônicos (f/2) em certas condições
        if let range = expectedRange {
            while frequency < range.lowerBound { frequency *= 2 }
            while frequency > range.upperBound { frequency /= 2 }
        }

        return MusicTheory.analyze(frequency: frequency)
    }

    // MARK: - Privado

    /// Pipeline FFT+HPS — mantido do detector original para uso como fallback.
    private func detectViaFFT(buffer: [Float], sampleRate: Float) -> Float? {

        guard buffer.count >= fftSize else { return nil }

        let start = max(0, buffer.count / 2 - fftSize / 2)
        var slice = Array(buffer[start..<start + fftSize])

        Windowing.applyHann(to: &slice)

        var magnitudes = fftProcessor.performFFT(input: slice)
        magnitudes = magnitudes.map { sqrt($0) }

        let hps = HarmonicProductSpectrum.apply(to: magnitudes, harmonics: 4) // 4 harmônicos vs 3 antigos

        return estimator.estimate(magnitudes: hps, fftSize: fftSize, sampleRate: sampleRate)
    }

    /// Calcula a distância em cents entre duas frequências.
    /// Positivo = `b` é mais agudo que `a`.
    private func centsDistance(from a: Float, to b: Float) -> Float {
        guard a > 0, b > 0 else { return Float.infinity }
        return 1200 * log2(b / a)
    }
}
#endif