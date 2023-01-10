//
//  JXSegmentedIndicatorProtocol.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit

public protocol JXSegmentedIndicatorProtocol {
    var isIndicatorConvertToItemFrameEnabled: Bool { get }
    

    func refreshIndicatorState(model: JXSegmentedIndicatorSelectedParams)

    func contentScrollViewDidScroll(model: JXSegmentedIndicatorTransitionParams)

    func selectItem(model: JXSegmentedIndicatorSelectedParams)
}
