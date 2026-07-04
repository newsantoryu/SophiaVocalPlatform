import Foundation

public final class FakeBufferProvider: AudioBufferProvider {

    private let buffers: [[Float]]

    public init(buffers: [[Float]]) {
        self.buffers = buffers
    }

    public func start(
        onBuffer: @escaping ([Float]) -> Void
    ) throws {

        for buffer in buffers {
            onBuffer(buffer)
        }
    }

    public func stop() { }
}