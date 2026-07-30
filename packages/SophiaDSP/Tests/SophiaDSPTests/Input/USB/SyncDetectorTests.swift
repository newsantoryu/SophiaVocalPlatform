import Foundation
import Testing
@testable import SophiaDSP

@Suite("Sync Detector Tests")
struct SyncDetectorTests {

    @Test
    func findSync() {

        let bytes = Data([
            0x10,
            0x20,
            0xAA,
            0x55,
            0x99
        ])

        let detector = SyncDetector()

        #expect(detector.findSync(in: bytes) == 2)

    }

    @Test
    func noSync() {

        let detector = SyncDetector()

        #expect(
            detector.findSync(
                in: Data([1,2,3])
            ) == nil
        )

    }

}
