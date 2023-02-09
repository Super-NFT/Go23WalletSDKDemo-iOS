//
//  JXPagingViewMainTableView.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/5/22.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

@objc protocol JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
}

class JXPagingMainTableView: UITableView, UIGestureRecognizerDelegate {
    weak var gestureDelegate: JXPagingMainTableViewGestureDelegate?

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureDelegate != nil {
            return gestureDelegate!.mainTableViewGestureRecognizer(gestureRecognizer, shouldRecognizeSimultaneouslyWith:otherGestureRecognizer)
        }else {
            return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
        }
    }
}
