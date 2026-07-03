//
//  PitchResult.swift
//
//  Created by victor almeida on 05/05/26.
//
import Foundation
public struct PitchResult {

    /// Frequência fundamental detectada em Hz
    public let frequency: Float

    /// Nota MIDI contínua (ex: 69.3 = A4 com desvio de 30 cents)
    public let midNote: Float

    /// Nome da nota mais próxima com oitava (ex: "A4", "C#3")
    public let noteName: String

    /// Desvio em cents em relação à nota MIDI mais próxima
    /// Positivo = agudo, Negativo = grave
    public let cents: Float
}
