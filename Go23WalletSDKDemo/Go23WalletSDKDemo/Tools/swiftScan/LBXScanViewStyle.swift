//
//  LBXScanViewStyle.swift
//  swiftScan
//
//  Created by xialibing on 15/12/8.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit

enum LBXScanViewAnimationStyle {
    case LineMove
    case NetGrid
    case LineStill
    case None
}

enum LBXScanViewPhotoframeAngleStyle {
    case Inner
    case Outer
    case On
}


struct LBXScanViewStyle {
    

    var isNeedShowRetangle = true

    var whRatio: CGFloat = 1.0

    var centerUpOffset: CGFloat = 44

    var xScanRetangleOffset: CGFloat = 60

    var colorRetangleLine = UIColor.white
    
    var widthRetangleLine: CGFloat = 1.0


    var photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Outer

    var colorAngle = UIColor(red: 0.0, green: 167.0 / 255.0, blue: 231.0 / 255.0, alpha: 1.0)

    var photoframeAngleW: CGFloat = 24.0
    var photoframeAngleH: CGFloat = 24.0
    
    var photoframeLineW: CGFloat = 6


    var anmiationStyle = LBXScanViewAnimationStyle.LineMove

    var animationImage: UIImage?


    var color_NotRecoginitonArea = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)

    init() { }
    
}
