
// ─────────────────────────────────────────────────────────────────────────────
// MARK: - MusicTheory
// ─────────────────────────────────────────────────────────────────────────────
import Foundation

public struct MusicTheory {

    public static let noteNames = [
        "C", "C#", "D", "D#",
        "E", "F", "F#",
        "G", "G#", "A",
        "A#", "B"
    ]

    public static func analyze(frequency: Float) -> PitchResult? {
        guard frequency > 0 else { return nil }

        let midi        = 69 + 12 * log2(frequency / 440)
        let roundedMidi = round(midi)
        let cents       = (midi - roundedMidi) * 100

        let noteIndex = ((Int(roundedMidi) % 12) + 12) % 12  // guard negativo
        let octave    = Int(roundedMidi) / 12 - 1
        let name      = noteNames[noteIndex] + "\(octave)"

        return PitchResult(
            frequency: frequency,
            midNote: midi,
            noteName: name,
            cents: cents
        )
    }

    /// Retorna apenas o nome da nota sem oitava (ex: "C#" de "C#3").
    /// Usado no alinhamento por grau melódico para comparar vozes em oitavas diferentes.
    public static func pitchClass(from noteName: String) -> String {
        // Remove dígitos e sinal negativo da oitava — mantém só a nota (ex: "C#", "A")
        return noteName.components(separatedBy: CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "-"))).first ?? noteName
    }
}