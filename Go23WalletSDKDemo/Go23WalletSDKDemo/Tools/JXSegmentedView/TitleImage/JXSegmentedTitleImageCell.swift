//
//  JXSegmentedTitleImageCell.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/29.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

class JXSegmentedTitleImageCell: JXSegmentedTitleCell {
    let imageView = UIImageView()
    private var currentImageInfo: String?

    override func prepareForReuse() {
        super.prepareForReuse()

        currentImageInfo = nil
    }

    override func commonInit() {
        super.commonInit()

        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let myItemModel = itemModel as? JXSegmentedTitleImageItemModel else {
            return
        }

        let imageSize = myItemModel.imageSize
        switch myItemModel.titleImageType {
            case .topImage:
                let contentHeight = imageSize.height + myItemModel.titleImageSpacing + titleLabel.bounds.size.height
                imageView.center = CGPoint(x: contentView.bounds.size.width/2, y: (contentView.bounds.size.height - contentHeight)/2 + imageSize.height/2)
                titleLabel.center = CGPoint(x: contentView.bounds.size.width/2, y: imageView.frame.maxY + myItemModel.titleImageSpacing + titleLabel.bounds.size.height/2)
            case .leftImage:
                let contentWidth = imageSize.width + myItemModel.titleImageSpacing + titleLabel.bounds.size.width
                imageView.center = CGPoint(x: (contentView.bounds.size.width - contentWidth)/2 + imageSize.width/2, y: contentView.bounds.size.height/2)
                titleLabel.center = CGPoint(x: imageView.frame.maxX + myItemModel.titleImageSpacing + titleLabel.bounds.size.width/2, y: contentView.bounds.size.height/2)
            case .bottomImage:
                let contentHeight = imageSize.height + myItemModel.titleImageSpacing + titleLabel.bounds.size.height
                titleLabel.center = CGPoint(x: contentView.bounds.size.width/2, y: (contentView.bounds.size.height - contentHeight)/2 + titleLabel.bounds.size.height/2)
                imageView.center = CGPoint(x: contentView.bounds.size.width/2, y: titleLabel.frame.maxY + myItemModel.titleImageSpacing + imageSize.height/2)
            case .rightImage:
                let contentWidth = imageSize.width + myItemModel.titleImageSpacing + titleLabel.bounds.size.width
                titleLabel.center = CGPoint(x: (contentView.bounds.size.width - contentWidth)/2 + titleLabel.bounds.size.width/2, y: contentView.bounds.size.height/2)
                imageView.center = CGPoint(x: titleLabel.frame.maxX + myItemModel.titleImageSpacing + imageSize.width/2, y: contentView.bounds.size.height/2)
            case .onlyImage:
                imageView.center = CGPoint(x: contentView.bounds.size.width/2, y: contentView.bounds.size.height/2)
            case .onlyTitle:
                titleLabel.center = CGPoint(x: contentView.bounds.size.width/2, y: contentView.bounds.size.height/2)
        }
    }

    override func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let myItemModel = itemModel as? JXSegmentedTitleImageItemModel else {
            return
        }

        titleLabel.isHidden = false
        imageView.isHidden = false
        if myItemModel.titleImageType == .onlyTitle {
            imageView.isHidden = true
        }else if myItemModel.titleImageType == .onlyImage {
            titleLabel.isHidden = true
        }

        imageView.bounds = CGRect(x: 0, y: 0, width: myItemModel.imageSize.width, height: myItemModel.imageSize.height)

        var normalImageInfo = myItemModel.normalImageInfo
        if myItemModel.isSelected && myItemModel.selectedImageInfo != nil {
            normalImageInfo = myItemModel.selectedImageInfo
        }

        if normalImageInfo != nil && normalImageInfo != currentImageInfo {
            currentImageInfo = normalImageInfo
            if myItemModel.loadImageClosure != nil {
                myItemModel.loadImageClosure!(imageView, normalImageInfo!)
            }else {
                imageView.image = UIImage(named: normalImageInfo!)
            }
        }

        if myItemModel.isImageZoomEnabled {
            imageView.transform = CGAffineTransform(scaleX: myItemModel.imageCurrentZoomScale, y: myItemModel.imageCurrentZoomScale)
        }else {
            imageView.transform = .identity
        }

        setNeedsLayout()
    }
}
