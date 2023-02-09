//
//  JXSegmentedIndicatorBaseView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

enum JXSegmentedIndicatorPosition {
    case top
    case bottom
    case center
}

class JXSegmentedIndicatorBaseView: UIView, JXSegmentedIndicatorProtocol {
    var indicatorWidth: CGFloat = JXSegmentedViewAutomaticDimension
    var indicatorWidthIncrement: CGFloat = 0 
    var indicatorHeight: CGFloat = JXSegmentedViewAutomaticDimension
    var indicatorCornerRadius: CGFloat = JXSegmentedViewAutomaticDimension
    var indicatorColor: UIColor = .red
    var indicatorPosition: JXSegmentedIndicatorPosition = .bottom
    var verticalOffset: CGFloat = 0
    var isScrollEnabled: Bool = true
    var isIndicatorConvertToItemFrameEnabled: Bool = true
    var scrollAnimationDuration: TimeInterval = 0.25
    var isIndicatorWidthSameAsItemContent = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    func commonInit() {
    }

    func getIndicatorCornerRadius(itemFrame: CGRect) -> CGFloat {
        if indicatorCornerRadius == JXSegmentedViewAutomaticDimension {
            return getIndicatorHeight(itemFrame: itemFrame)/2
        }
        return indicatorCornerRadius
    }

    func getIndicatorWidth(itemFrame: CGRect, itemContentWidth: CGFloat) -> CGFloat {
        if indicatorWidth == JXSegmentedViewAutomaticDimension {
            if isIndicatorWidthSameAsItemContent {
                return itemContentWidth + indicatorWidthIncrement
            }else {
                return itemFrame.size.width + indicatorWidthIncrement
            }
        }
        return indicatorWidth + indicatorWidthIncrement
    }

    func getIndicatorHeight(itemFrame: CGRect) -> CGFloat {
        if indicatorHeight == JXSegmentedViewAutomaticDimension {
            return itemFrame.size.height
        }
        return indicatorHeight
    }

    func canHandleTransition(model: JXSegmentedIndicatorTransitionParams) -> Bool {
        if model.percent == 0 || !isScrollEnabled {
            return false
        }
        return true
    }

    func canSelectedWithAnimation(model: JXSegmentedIndicatorSelectedParams) -> Bool {
        if isScrollEnabled && (model.selectedType == .click || model.selectedType == .code) {
            return true
        }
        return false
    }

    func refreshIndicatorState(model: JXSegmentedIndicatorSelectedParams) {
    }

    func contentScrollViewDidScroll(model: JXSegmentedIndicatorTransitionParams) {
    }

    func selectItem(model: JXSegmentedIndicatorSelectedParams) {
    }
}
