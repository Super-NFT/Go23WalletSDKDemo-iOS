//
//  JXSegmentedNumberItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit

class JXSegmentedNumberItemModel: JXSegmentedTitleItemModel {
    var number: Int = 0
    var numberString: String = "0"
    var numberBackgroundColor: UIColor = .red
    var numberTextColor: UIColor = .white
    var numberWidthIncrement: CGFloat = 0
    var numberFont: UIFont = UIFont.systemFont(ofSize: 11)
    var numberOffset: CGPoint = CGPoint.zero
    var numberHeight: CGFloat = 14
}
