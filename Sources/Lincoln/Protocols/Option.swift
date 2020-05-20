// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// A Swifty alternative to OptionSet.
///
/// Courtesy of [NSHipster](https://nshipster.com/optionset/)
public protocol Option: RawRepresentable, Hashable, CaseIterable {}

extension Set where Element: Option {
    public var rawValue: Int {
        var rawValue = 0
        for (index, element) in Element.allCases.enumerated() {
            if self.contains(element) {
                rawValue |= (1 << index)
            }
        }
        
        return rawValue
    }
}
