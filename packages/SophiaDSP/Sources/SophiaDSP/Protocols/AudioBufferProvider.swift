import Foundation

public protocol AudioBufferProvider {

    func start(
        onBuffer: @escaping ([Float]) -> Void
    ) throws

    func stop()
}