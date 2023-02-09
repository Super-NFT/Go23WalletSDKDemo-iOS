//
//  UIView+Frame.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/9.
//

import Foundation
import UIKit

extension UIView{
    var hd_width :CGFloat{
        get { return frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var hd_height :CGFloat{
        get { return frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var hd_size :CGSize{
        get { return frame.size }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    var hd_origin :CGPoint{
        get { return frame.origin }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }

    var hd_x :CGFloat{
        get { return frame.origin.x}
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    var hd_y :CGFloat{
        get { return frame.origin.y}
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    var hd_centerX :CGFloat{
        get { return center.x}
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }

    var hd_centerY :CGFloat{
        get { return center.y}
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }

    
}
