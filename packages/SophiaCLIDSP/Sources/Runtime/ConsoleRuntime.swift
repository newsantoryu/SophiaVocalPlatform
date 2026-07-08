import Foundation
import SophiaDSP

public final class ConsoleRuntime {

    private let engine: DSPStreamEngine
    private let printer: ConsolePrinter

    public init(
        engine: DSPStreamEngine,
        printer: ConsolePrinter = ConsolePrinter()
    ) {
        self.engine = engine
        self.printer = printer
    }

    public func start() throws {

        try engine.start { [weak self] packet in
            self?.printer.print(packet)
        }
    }

    public func stop() {
        engine.stop()
    }
}