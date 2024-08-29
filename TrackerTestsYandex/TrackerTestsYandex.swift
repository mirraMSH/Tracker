//
//  TrackerTestsYnadex.swift
//  TrackerTestsYnadex
//
//  Created by Мария Шагина on 29.08.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker


final class TrackerTestsYandex: XCTestCase {

    func testTrackersVCLight() throws {
        let vc = TrackerViewController()
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackersVCDark() throws {
        let vc = TrackerViewController()
        assertSnapshot(
            of: vc,
            as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
