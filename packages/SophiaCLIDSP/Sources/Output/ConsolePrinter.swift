import Foundation
import SophiaDSP

public final class ConsolePrinter {

    public init() {}

    public func print(_ packet: DSPPacket) {

        let frequency = packet.frequency.map {
            String(format: "%.2f Hz", $0)
        } ?? "--"

        let rms = String(format: "%.4f", packet.rms)

        let confidence = String(
            format: "%.2f",
            packet.confidence
        )

        let voice = packet.isVoice ? "VOICE" : "SILENCE"

        Swift.print("""
              ----------------------------
              Time       : \(packet.timestamp)
              Voice      : \(voice)
              Frequency  : \(frequency)
              RMS        : \(rms)
              Confidence : \(confidence)
              ----------------------------
              """)
    }
}