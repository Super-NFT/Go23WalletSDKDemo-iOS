//
//  JXSegmentedDotDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedDotDataSource: JXSegmentedTitleDataSource {
    var dotStates = [Bool]()
    var dotSize = CGSize(width: 10, height: 10)
    var dotCornerRadius: CGFloat = JXSegmentedViewAutomaticDimension
    var dotColor = UIColor.red
    var dotOffset: CGPoint = CGPoint.zero

    override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedDotItemModel()
    }

    override func preferredRefreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? JXSegmentedDotItemModel else {
            return
        }

        itemModel.dotOffset = dotOffset
        itemModel.dotState = dotStates[index]
        itemModel.dotColor = dotColor
        itemModel.dotSize = dotSize
        if dotCornerRadius == JXSegmentedViewAutomaticDimension {
            itemModel.dotCornerRadius = dotSize.height/2
        }else {
            itemModel.dotCornerRadius = dotCornerRadius
        }
    }

    override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.collectionView.register(JXSegmentedDotCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }
}
