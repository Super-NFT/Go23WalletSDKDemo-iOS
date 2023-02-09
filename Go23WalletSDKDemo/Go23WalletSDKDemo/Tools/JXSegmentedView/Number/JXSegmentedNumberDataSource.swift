//
//  JXSegmentedNumberDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/28.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import Foundation
import UIKit

class JXSegmentedNumberDataSource: JXSegmentedTitleDataSource {
    var numbers = [Int]()
    var numberWidthIncrement: CGFloat = 10
    var numberBackgroundColor: UIColor = .red
    var numberTextColor: UIColor = .white
    var numberFont: UIFont = UIFont.systemFont(ofSize: 11)
    var numberOffset: CGPoint = CGPoint.zero
    var numberStringFormatterClosure: ((Int) -> String)?
    var numberHeight: CGFloat = 14

    override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedNumberItemModel()
    }

    override func preferredRefreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? JXSegmentedNumberItemModel else {
            return
        }

        itemModel.number = numbers[index]
        if numberStringFormatterClosure != nil {
            itemModel.numberString = numberStringFormatterClosure!(itemModel.number)
        }else {
            itemModel.numberString = "\(itemModel.number)"
        }
        itemModel.numberTextColor = numberTextColor
        itemModel.numberBackgroundColor = numberBackgroundColor
        itemModel.numberOffset = numberOffset
        itemModel.numberWidthIncrement = numberWidthIncrement
        itemModel.numberHeight = numberHeight
    }

    override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.collectionView.register(JXSegmentedNumberCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }
}
