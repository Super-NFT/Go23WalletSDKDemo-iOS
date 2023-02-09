//
//  JXSegmentedTitleAttributeDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/2.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedTitleAttributeDataSource: JXSegmentedBaseDataSource {
    var attributedTitles = [NSAttributedString]()
    var selectedAttributedTitles: [NSAttributedString]?
    var widthForTitleClosure: ((NSAttributedString)->(CGFloat))?
    var titleNumberOfLines: Int = 2

    override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedTitleAttributeItemModel()
    }

    override func preferredItemCount() -> Int {
        return attributedTitles.count
    }

    override func preferredRefreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let myItemModel = itemModel as? JXSegmentedTitleAttributeItemModel else {
            return
        }

        myItemModel.attributedTitle = attributedTitles[index]
        myItemModel.selectedAttributedTitle = selectedAttributedTitles?[index]
        myItemModel.textWidth = widthForTitle(myItemModel.attributedTitle, selectedTitle: myItemModel.selectedAttributedTitle)
        myItemModel.titleNumberOfLines = titleNumberOfLines
    }

    func widthForTitle(_ title: NSAttributedString?, selectedTitle: NSAttributedString?) -> CGFloat {
        let attriText = selectedTitle != nil ? selectedTitle : title
        guard let text = attriText else {
            return 0
        }
        if widthForTitleClosure != nil {
            return widthForTitleClosure!(text)
        }else {
            let textWidth = text.boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: NSStringDrawingOptions.init(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), context: nil).size.width
            return CGFloat(ceilf(Float(textWidth)))
        }
    }


    override func preferredSegmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        var width: CGFloat = 0
        if itemWidth == JXSegmentedViewAutomaticDimension {
            let myItemModel = dataSource[index] as! JXSegmentedTitleAttributeItemModel
            width = myItemModel.textWidth + itemWidthIncrement
        }else {
            width = itemWidth + itemWidthIncrement
        }
        return width
    }

    override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.collectionView.register(JXSegmentedTitleAttributeCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }
}
