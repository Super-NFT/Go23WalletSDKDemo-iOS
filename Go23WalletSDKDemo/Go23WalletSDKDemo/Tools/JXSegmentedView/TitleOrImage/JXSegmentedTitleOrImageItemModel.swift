//
//  JXSegmentedTitleOrImageItemModel.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedTitleOrImageItemModel: JXSegmentedTitleItemModel {
    var selectedImageInfo: String?
    var loadImageClosure: LoadImageClosure?
    var imageSize: CGSize = CGSize.zero
}
