//
//  JXSegmentedTitleImageDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

enum JXSegmentedTitleImageType {
    case topImage
    case leftImage
    case bottomImage
    case rightImage
    case onlyImage
    case onlyTitle
}

typealias LoadImageClosure = ((UIImageView, String) -> Void)

class JXSegmentedTitleImageDataSource: JXSegmentedTitleDataSource {
    var titleImageType: JXSegmentedTitleImageType = .rightImage
    var normalImageInfos: [String]?
    var selectedImageInfos: [String]?
    var loadImageClosure: LoadImageClosure?
    var imageSize: CGSize = CGSize(width: 20, height: 20)
    var titleImageSpacing: CGFloat = 5
    var isImageZoomEnabled: Bool = false
    var imageSelectedZoomScale: CGFloat = 1.2

    override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedTitleImageItemModel()
    }

    override func preferredRefreshItemModel(_ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? JXSegmentedTitleImageItemModel else {
            return
        }

        itemModel.titleImageType = titleImageType
        itemModel.normalImageInfo = normalImageInfos?[index]
        itemModel.selectedImageInfo = selectedImageInfos?[index]
        itemModel.loadImageClosure = loadImageClosure
        itemModel.imageSize = imageSize
        itemModel.isImageZoomEnabled = isImageZoomEnabled
        itemModel.imageNormalZoomScale = 1
        itemModel.imageSelectedZoomScale = imageSelectedZoomScale
        itemModel.titleImageSpacing = titleImageSpacing
        if index == selectedIndex {
            itemModel.imageCurrentZoomScale = itemModel.imageSelectedZoomScale
        }else {
            itemModel.imageCurrentZoomScale = itemModel.imageNormalZoomScale
        }
    }

    override func preferredSegmentedView(_ segmentedView: JXSegmentedView, widthForItemAt index: Int) -> CGFloat {
        var width = super.preferredSegmentedView(segmentedView, widthForItemAt: index)
        if itemWidth == JXSegmentedViewAutomaticDimension {
            switch titleImageType {
            case .leftImage, .rightImage:
                width += titleImageSpacing + imageSize.width
            case .topImage, .bottomImage:
                width = max(itemWidth, imageSize.width)
            case .onlyImage:
                width = imageSize.width
            case .onlyTitle:
                break
            }
        }
        return width
    }

    override func segmentedView(_ segmentedView: JXSegmentedView, widthForItemContentAt index: Int) -> CGFloat {
        var width = super.segmentedView(segmentedView, widthForItemContentAt: index)
        switch titleImageType {
        case .leftImage, .rightImage:
            width += titleImageSpacing + imageSize.width
        case .topImage, .bottomImage:
            width = max(itemWidth, imageSize.width)
        case .onlyImage:
            width = imageSize.width
        case .onlyTitle:
            break
        }
        return width
    }

    override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.collectionView.register(JXSegmentedTitleImageCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }

    override func refreshItemModel(_ segmentedView: JXSegmentedView, leftItemModel: JXSegmentedBaseItemModel, rightItemModel: JXSegmentedBaseItemModel, percent: CGFloat) {
        super.refreshItemModel(segmentedView, leftItemModel: leftItemModel, rightItemModel: rightItemModel, percent: percent)

        guard let leftModel = leftItemModel as? JXSegmentedTitleImageItemModel, let rightModel = rightItemModel as? JXSegmentedTitleImageItemModel else {
            return
        }
        if isImageZoomEnabled && isItemTransitionEnabled {
            leftModel.imageCurrentZoomScale = JXSegmentedViewTool.interpolate(from: imageSelectedZoomScale, to: 1, percent: CGFloat(percent))
            rightModel.imageCurrentZoomScale = JXSegmentedViewTool.interpolate(from: 1, to: imageSelectedZoomScale, percent: CGFloat(percent))
        }
    }

    override func refreshItemModel(_ segmentedView: JXSegmentedView, currentSelectedItemModel: JXSegmentedBaseItemModel, willSelectedItemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.refreshItemModel(segmentedView, currentSelectedItemModel: currentSelectedItemModel, willSelectedItemModel: willSelectedItemModel, selectedType: selectedType)

        guard let myCurrentSelectedItemModel = currentSelectedItemModel as? JXSegmentedTitleImageItemModel, let myWillSelectedItemModel = willSelectedItemModel as? JXSegmentedTitleImageItemModel else {
            return
        }

        myCurrentSelectedItemModel.imageCurrentZoomScale = myCurrentSelectedItemModel.imageNormalZoomScale
        myWillSelectedItemModel.imageCurrentZoomScale = myWillSelectedItemModel.imageSelectedZoomScale
    }
}
