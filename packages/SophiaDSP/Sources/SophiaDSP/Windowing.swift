import Foundation

public struct Windowing {

    public static func applyHann(to buffer: inout [Float]) {

        let count = buffer.count

        guard count > 1 else { return }

        for i in 0..<count {

            let multiplier =
                0.5 * (1 - cos(2.0 * Float.pi * Float(i) / Float(count - 1)))

            buffer[i] *= Float(multiplier)
        }
    }
}