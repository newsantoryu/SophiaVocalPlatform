import Foundation

public protocol AudioSource {
    var metadata: AudioMetadata { get }
    func open() throws
    func read() throws -> Data?
    func close()
}