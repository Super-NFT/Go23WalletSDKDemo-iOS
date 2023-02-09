//
//  JXSegmentedTitleOrImageDataSource.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2019/1/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedTitleOrImageDataSource: JXSegmentedTitleDataSource {
    var selectedImageInfos: [String?]?
    var loadImageClosure: LoadImageClosure?
    
    var imageSize: CGSize = CGSize(width: 30, height: 30)

    override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedTitleOrImageItemModel()
    }

    override func reloadData(selectedIndex: Int) {
        selectedAnimationDuration = 0.1

        super.reloadData(selectedIndex: selectedIndex)
    }

    override func preferredRefreshItemModel( _ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let itemModel = itemModel as? JXSegmentedTitleOrImageItemModel else {
            return
        }

        itemModel.selectedImageInfo = selectedImageInfos?[index]
        itemModel.loadImageClosure = loadImageClosure
        itemModel.imageSize = imageSize
    }

    override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.collectionView.register(JXSegmentedTitleOrImageCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }

}
