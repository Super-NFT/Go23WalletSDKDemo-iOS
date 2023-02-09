//
//  JXSegmentedTitleGradientItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedTitleGradientItemModel: JXSegmentedTitleItemModel {
    var titleNormalGradientColors: [CGColor] = [CGColor]()
    var titleCurrentGradientColors: [CGColor] = [CGColor]()
    var titleSelectedGradientColors: [CGColor] = [CGColor]()
    var titleGradientStartPoint: CGPoint = CGPoint.zero
    var titleGradientEndPoint: CGPoint = CGPoint.zero
}
