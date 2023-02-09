//
//  JXSegmentedBaseItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit

class JXSegmentedBaseItemModel {
    var index: Int = 0
    var isSelected: Bool = false
    var itemWidth: CGFloat = 0
    var indicatorConvertToItemFrame: CGRect = CGRect.zero
    var isItemTransitionEnabled: Bool = true
    var isSelectedAnimable: Bool = false
    var selectedAnimationDuration: TimeInterval = 0
    var isTransitionAnimating: Bool = false
    var isItemWidthZoomEnabled: Bool = false
    var itemWidthNormalZoomScale: CGFloat = 0
    var itemWidthCurrentZoomScale: CGFloat = 0
    var itemWidthSelectedZoomScale: CGFloat = 0

    init() {
    }
}
