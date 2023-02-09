//
//  JXSegmentedIndicatorRainbowLineView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit


class JXSegmentedIndicatorRainbowLineView: JXSegmentedIndicatorLineView {
    var indicatorColors = [UIColor]()

    override func refreshIndicatorState(model: JXSegmentedIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        backgroundColor = indicatorColors[model.currentSelectedIndex]
    }

    override func contentScrollViewDidScroll(model: JXSegmentedIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)

        guard canHandleTransition(model: model) else {
            return
        }

        backgroundColor = JXSegmentedViewTool.interpolateColor(from: indicatorColors[model.leftIndex], to: indicatorColors[model.rightIndex], percent: model.percent)
    }

    override func selectItem(model: JXSegmentedIndicatorSelectedParams) {
        super.selectItem(model: model)

        backgroundColor = indicatorColors[model.currentSelectedIndex]
    }

}
