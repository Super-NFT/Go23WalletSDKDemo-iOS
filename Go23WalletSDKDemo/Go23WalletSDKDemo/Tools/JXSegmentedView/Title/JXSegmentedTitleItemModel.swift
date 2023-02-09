//
//  JXSegmentedTitleItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedTitleItemModel: JXSegmentedBaseItemModel {
    var title: String?
    var titleNumberOfLines: Int = 0
    var titleNormalColor: UIColor = .black
    var titleCurrentColor: UIColor = .black
    var titleSelectedColor: UIColor = .red
    var titleNormalFont: UIFont = UIFont.systemFont(ofSize: 15)
    var titleSelectedFont: UIFont = UIFont.systemFont(ofSize: 15)
    var isTitleZoomEnabled: Bool = false
    var titleNormalZoomScale: CGFloat = 0
    var titleCurrentZoomScale: CGFloat = 0
    var titleSelectedZoomScale: CGFloat = 0
    var isTitleStrokeWidthEnabled: Bool = false
    var titleNormalStrokeWidth: CGFloat = 0
    var titleCurrentStrokeWidth: CGFloat = 0
    var titleSelectedStrokeWidth: CGFloat = 0
    var isTitleMaskEnabled: Bool = false
    var textWidth: CGFloat = 0
    var kern: CGFloat = 0
}
