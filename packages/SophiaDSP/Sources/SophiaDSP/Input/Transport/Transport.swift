import Foundation

public protocol Transport {

    func open() throws

    func read(maxLength: Int) throws -> Data

    func write(_ data: Data) throws

    func close()

    var isOpen: Bool { get }
}