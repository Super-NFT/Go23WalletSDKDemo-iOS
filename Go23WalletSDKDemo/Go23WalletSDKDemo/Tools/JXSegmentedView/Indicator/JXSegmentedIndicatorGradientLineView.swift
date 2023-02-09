//
//  JXSegmentedIndicatorGradientLineView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2020/7/6.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedIndicatorGradientLineView: JXSegmentedIndicatorLineView {
    var colors = [UIColor]()
    var startPoint = CGPoint.zero
    var endPoint = CGPoint(x: 1, y: 0)
    var locations: [NSNumber]?
    let gradientLayer = CAGradientLayer()

    override func commonInit() {
        super.commonInit()

        layer.masksToBounds = true
        layer.addSublayer(gradientLayer)
    }

    override func refreshIndicatorState(model: JXSegmentedIndicatorSelectedParams) {
        super.refreshIndicatorState(model: model)

        backgroundColor = .clear
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations = locations
        CATransaction.commit()
    }

    override func contentScrollViewDidScroll(model: JXSegmentedIndicatorTransitionParams) {
        super.contentScrollViewDidScroll(model: model)

        guard canHandleTransition(model: model) else {
            return
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = bounds
        CATransaction.commit()
    }

    override func selectItem(model: JXSegmentedIndicatorSelectedParams) {
        super.selectItem(model: model)

        let targetWidth = getIndicatorWidth(itemFrame: model.currentSelectedItemFrame, itemContentWidth: model.currentItemContentWidth)
        CATransaction.begin()
        CATransaction.setAnimationDuration(scrollAnimationDuration)
        CATransaction.setAnimationTimingFunction(.init(name: .easeOut))
        gradientLayer.frame.size.width = targetWidth
        CATransaction.commit()
    }

}
