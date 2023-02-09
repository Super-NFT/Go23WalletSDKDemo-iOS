//
//  JXSegmentedIndicatorParamsModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit

struct JXSegmentedIndicatorSelectedParams {
    let currentSelectedIndex: Int
    let currentSelectedItemFrame: CGRect
    let selectedType: JXSegmentedViewItemSelectedType
    let currentItemContentWidth: CGFloat
    var collectionViewContentSize: CGSize?

    init(currentSelectedIndex: Int, currentSelectedItemFrame: CGRect, selectedType: JXSegmentedViewItemSelectedType, currentItemContentWidth: CGFloat, collectionViewContentSize: CGSize?) {
        self.currentSelectedIndex = currentSelectedIndex
        self.currentSelectedItemFrame = currentSelectedItemFrame
        self.selectedType = selectedType
        self.currentItemContentWidth = currentItemContentWidth
        self.collectionViewContentSize = collectionViewContentSize
    }
}

struct JXSegmentedIndicatorTransitionParams {
    let currentSelectedIndex: Int
    let leftIndex: Int
    let leftItemFrame: CGRect
    let rightIndex: Int
    let rightItemFrame: CGRect
    let leftItemContentWidth: CGFloat
    let rightItemContentWidth: CGFloat
    let percent: CGFloat

    init(currentSelectedIndex: Int, leftIndex: Int, leftItemFrame: CGRect, leftItemContentWidth: CGFloat, rightIndex: Int, rightItemFrame: CGRect, rightItemContentWidth: CGFloat, percent: CGFloat) {
        self.currentSelectedIndex = currentSelectedIndex
        self.leftIndex = leftIndex
        self.leftItemFrame = leftItemFrame
        self.leftItemContentWidth = leftItemContentWidth
        self.rightIndex = rightIndex
        self.rightItemFrame = rightItemFrame
        self.rightItemContentWidth = rightItemContentWidth
        self.percent = percent
    }
}
