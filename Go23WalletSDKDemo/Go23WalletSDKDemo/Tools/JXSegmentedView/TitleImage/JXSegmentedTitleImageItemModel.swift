//
//  JXSegmentedTitleImageItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedTitleImageItemModel: JXSegmentedTitleItemModel {
    var titleImageType: JXSegmentedTitleImageType = .rightImage
    var normalImageInfo: String?
    var selectedImageInfo: String?
    var loadImageClosure: LoadImageClosure?
    var imageSize: CGSize = CGSize.zero
    var titleImageSpacing: CGFloat = 0
    var isImageZoomEnabled: Bool = false
    var imageNormalZoomScale: CGFloat = 0
    var imageCurrentZoomScale: CGFloat = 0
    var imageSelectedZoomScale: CGFloat = 0
}
