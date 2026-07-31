import Foundation

public struct SyncDetector {

    public init() {}

    public func findSync(
        in data: Data
    ) -> Int? {

        guard data.count >= 2 else {
            return nil
        }

        for index in 0..<(data.count - 1) {

            if data[index] == SATPHeader.sync0 &&
                data[index + 1] == SATPHeader.sync1 {

                return index
            }

        }

        return nil

    }

}