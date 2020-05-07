//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public struct SettingsToggleViewModel: BasicTableViewCellViewModel, Equatable, Hashable {
    public let title: String
    public var isOn: Bool
    public let subtitle: String? = nil
    public let detailText: String? = nil
    public let hasChevron = false

    public init(title: String, isOn: Bool) {
        self.title = title
        self.isOn = isOn
    }
}
