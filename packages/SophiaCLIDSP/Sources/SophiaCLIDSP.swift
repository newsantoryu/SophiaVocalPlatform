import Foundation
import SophiaDSP

@main
struct SophiaCLIDSP {

    static func main() {
        SophiaCLIDSP().processAudioFile()
    }

    func processAudioFile() {

        do {

            let arguments = CommandLine.arguments

            guard arguments.count >= 2 else {

                Swift.print("""
                Starting SophiaCLIDSP... 🚀

                Usage:

                  swift run SophiaCLIDSP <wav-file>

                Example:

                  swift run SophiaCLIDSP Samples/voice.wav
                """)

                return
            }

            let file = arguments[1]

            let command = AnalyzeCommand()

            try command.run(file: file)

        } catch {

            Swift.print("❌ Error processing audio file:")
            Swift.print(error)

        }
    }
}