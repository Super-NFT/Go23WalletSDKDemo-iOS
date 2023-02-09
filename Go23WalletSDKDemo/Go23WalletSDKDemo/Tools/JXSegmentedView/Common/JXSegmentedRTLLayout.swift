//
//  JXSegmentedRTLLayout.swift
//  JXSegmentedView
//
//  Created by blue on 2020/6/18.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import UIKit

protocol JXSegmentedViewRTLCompatible: class {
    func segmentedViewShouldRTLLayout() -> Bool
    func segmentedView(horizontalFlipForView view: UIView?)
}

extension JXSegmentedViewRTLCompatible {
    

    func segmentedViewShouldRTLLayout() -> Bool {
        return UIView.userInterfaceLayoutDirection(for: UIView.appearance().semanticContentAttribute) == .rightToLeft
    }
    
    func segmentedView(horizontalFlipForView view: UIView?) {
        view?.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
}

class JXSegmentedRTLCollectionCell: UICollectionViewCell, JXSegmentedViewRTLCompatible {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        if segmentedViewShouldRTLLayout() {
            segmentedView(horizontalFlipForView: self)
            segmentedView(horizontalFlipForView: contentView)
        }
    }
    
}
