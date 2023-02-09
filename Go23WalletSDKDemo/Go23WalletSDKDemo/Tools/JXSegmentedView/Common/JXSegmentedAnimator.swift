//
//  JXSegmentedAnimator.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import UIKit

class JXSegmentedAnimator {
    var duration: TimeInterval = 0.25
    var progressClosure: ((CGFloat)->())?
    var completedClosure: (()->())?
    private var displayLink: CADisplayLink!
    private var firstTimestamp: CFTimeInterval?

    init() {
        displayLink = CADisplayLink(target: self, selector: #selector(processDisplayLink(sender:)))
    }

    func start() {
        displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }

    func stop() {
        progressClosure?(1)
        displayLink.invalidate()
        completedClosure?()
    }

    @objc private func processDisplayLink(sender: CADisplayLink) {
        if firstTimestamp == nil {
            firstTimestamp = sender.timestamp
        }
        let percent = (sender.timestamp - firstTimestamp!)/duration
        if percent >= 1 {
            progressClosure?(1)
            displayLink.invalidate()
            completedClosure?()
        }else {
            progressClosure?(CGFloat(percent))
        }
    }
}
