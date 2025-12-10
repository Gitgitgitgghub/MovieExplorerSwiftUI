//
//  Color+UIKit.swift
//  MovieExplorerSwiftUI
//
//  Created by Brant on 2025/12/10.
//

import SwiftUI
import UIKit

extension Color {

    /// 方便在 UIKit 環境使用 SwiftUI Color。
    var uiColor: UIColor {
        UIColor(self)
    }

    /// 以 UIColor 建立 SwiftUI Color。
    init(uiColor: UIColor) {
        self.init(uiColor)
    }
}
