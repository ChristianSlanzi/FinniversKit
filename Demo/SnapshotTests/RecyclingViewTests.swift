//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Demo
import XCTest
import FinniversKit

class RecyclingViewTests: XCTestCase {
    private func snapshot(_ component: RecyclingDemoViews, includeIPad: Bool = false, delay: TimeInterval? = nil, testName: String = #function) {
        assertSnapshots(matching: component.viewController, includeDarkMode: true, includeIPad: includeIPad, delay: delay, testName: testName)
    }

    // MARK: - Tests

    func testMissingSnapshotTests() {
        for element in elementWithoutTests(for: RecyclingDemoViews.self) {
            XCTFail("Not all elements were implemented, missing: \(element.rawValue)")
        }
    }

    func testNotificationsListView() {
        snapshot(.notificationsListView)
    }

    func testMarketsGridView() {
        snapshot(.marketsGridView)
    }

    func testAdsGridView() {
        snapshot(.adsGridView)
    }

    func testFavoritesListView() {
        snapshot(.favoritesListView)
    }

    func testFavoriteFoldersListView() {
        snapshot(.favoriteFoldersListView)
    }

    func testSavedSearchesListView() {
        snapshot(.savedSearchesListView)
    }

    func testSettingsView() {
        snapshot(.settingsView)
    }

    func testAdManagementView() {
        snapshot(.adManagementView)
    }

    func testNeighborhoodProfileView() {
        snapshot(.neighborhoodProfileView)
    }

    func testBasicTableView() {
        snapshot(.basicTableView)
    }
}
