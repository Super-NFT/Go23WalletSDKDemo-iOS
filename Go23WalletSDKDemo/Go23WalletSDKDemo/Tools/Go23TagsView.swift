//
//  Go23SwipSelectView.swift
//  Go23WalletSDKDemo
//  LJTagsView
//  Created by luming on 2023/2/21.
//

import UIKit

/// Go23TagsViewProtocol
@objc public protocol Go23TagsViewProtocol: NSObjectProtocol {

    @objc optional func tagsViewUpdatePropertyModel(_ tagsView: Go23TagsView, item: TagsPropertyModel,index: NSInteger) -> Void
    @objc optional func tagsViewUpdateHeight(_ tagsView: Go23TagsView, sumHeight: CGFloat) -> Void
    @objc optional func tagsViewTapAction(_ tagsView: Go23TagsView) -> Void
    @objc optional func tagsViewItemTapAction(_ tagsView: Go23TagsView, item: TagsPropertyModel,index: NSInteger) -> Void
}


public enum tagsViewScrollDirection {
    case vertical
    case horizontal
}

public class Go23TagsView: UIView {
    
    public var dataSource: [String] = [] {
        didSet {
            config()
        }
    }
    
    public var modelDataSource: [TagsPropertyModel] = [] {
        didSet {
            config()
        }
    }
    
    public var minimumLineSpacing: CGFloat = 10.0
    public var minimumInteritemSpacing: CGFloat = 10.0
    public var tagsViewContentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    public var tagsViewMinHeight: CGFloat = 0.0 {
        didSet {
            tagsViewMinHeight = tagsViewMinHeight > tagsViewMaxHeight ? tagsViewMaxHeight : tagsViewMinHeight
        }
    }
    public var tagsViewMaxHeight: CGFloat = CGFloat(MAXFLOAT) {
        didSet {
            tagsViewMaxHeight = tagsViewMaxHeight < tagsViewMinHeight ? tagsViewMinHeight : tagsViewMaxHeight
        }
    }
    public var scrollDirection : tagsViewScrollDirection = .vertical
    
    open weak var tagsViewDelegate : Go23TagsViewProtocol?
    public var showLine: UInt = 0 {
        willSet {
            if newValue > 0 {
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tagsViewTapAction))
                self.addGestureRecognizer(tap)
            }
        }
    }
    public var arrowImageView: UIImageView = UIImageView.init(image: UIImage.init(named: "arrow")?.withRenderingMode(.alwaysOriginal))
    public var isSelect = false
    
    private var tagsViewWidth = UIScreen.main.bounds.width
    
   
    private var dealDataSource: [TagsPropertyModel] = [TagsPropertyModel]()
    
    var scrollView = UIScrollView()
    
    private var contentSize = CGSize.zero
    
    var currentOffent = CGSize.zero
    var selectModel: TagsPropertyModel = TagsPropertyModel()
    
    public override init(frame:CGRect) {
        super.init(frame: frame)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        arrowImageView.isHidden = true
        addSubview(scrollView)
        addSubview(arrowImageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Go23TagsView {
    
    public func reloadData() -> Void {
        
        layoutIfNeeded()
        
        var tagX: CGFloat = tagsViewContentInset.left
        var tagY: CGFloat = tagsViewContentInset.top
        var tagW: CGFloat = 0.0
        var tagH: CGFloat = 0.0
        
        var labelW: CGFloat = 0.0
        var labelH: CGFloat = 0.0
        var LableY: CGFloat = 0.0
        var imageY: CGFloat = 0.0
        
        var nextTagW: CGFloat = 0.0
        var currentLine: UInt = 1
        var showLineDataSource: [TagsPropertyModel] = [TagsPropertyModel]()
        
        arrowImageView.isHidden = !(dealDataSource.count > 0 && showLine > 0)
        if arrowImageView.isHidden {
            tagsViewWidth = frame.width
        }else {
            let arrowImageViewSize = arrowImageView.bounds.size
            arrowImageView.frame = CGRect(x: frame.width - tagsViewContentInset.right - arrowImageViewSize.width, y: tagsViewContentInset.top, width: arrowImageViewSize.width, height: arrowImageViewSize.height)
            tagsViewWidth = frame.width - arrowImageViewSize.width - 10
            let angle = isSelect == true ? Double.pi : 0.0
            UIView.animate(withDuration: 0.3) { [unowned self] in
                arrowImageView.transform = CGAffineTransform.init(rotationAngle: CGFloat(angle))
            }
        }
        
        for (index,propertyModel) in dealDataSource.enumerated() {
            if propertyModel.isSelected {
                selectModel = propertyModel
            }
            if  tagsViewDelegate?.responds(to: #selector(tagsViewDelegate?.tagsViewItemTapAction(_:item:index:))) ?? false {
                let tap = UITapGestureRecognizer(target: self, action: #selector(contentViewTapAction(gestureRecongizer:)))
                propertyModel.contentView.addGestureRecognizer(tap)
            }
            
            propertyModel.contentView.tag = index
            
            tagW = tagWidth(propertyModel)
            
            switch scrollDirection {
            case .vertical:
                if tagW > tagsViewWidth - tagsViewContentInset.left - tagsViewContentInset.right {
                    tagW = tagsViewWidth - tagsViewContentInset.left - tagsViewContentInset.right
                }
            case .horizontal:
                break
            }
            
            labelW = tagW - (propertyModel.contentInset.left + propertyModel.contentInset.right + propertyModel.tagContentPadding + propertyModel.imageWidth)
            
            labelH = tagHeight(propertyModel, width: labelW)
            
            let contentH = labelH < propertyModel.imageHeight ? propertyModel.imageHeight : labelH
            
            tagH = contentH + propertyModel.contentInset.top + propertyModel.contentInset.bottom
            
            tagH = tagH < propertyModel.minHeight ? propertyModel.minHeight : tagH
            
            LableY = (tagH - labelH) * 0.5
            
            imageY = (tagH - propertyModel.imageHeight) * 0.5
            
            propertyModel.contentView.frame = CGRect(x: tagX, y: tagY, width: tagW, height: tagH)
            
            switch propertyModel.imageAlignmentMode {
            case .left:
                propertyModel.imageView.frame = CGRect(x: propertyModel.contentInset.left, y: imageY, width: propertyModel.imageWidth, height: propertyModel.imageHeight)
                propertyModel.titleLabel.frame = CGRect(x:  propertyModel.imageView.frame.maxX + propertyModel.tagContentPadding, y: LableY, width: labelW, height: labelH)
            case .right:
                propertyModel.titleLabel.frame = CGRect(x: propertyModel.contentInset.left, y: LableY, width: labelW, height: labelH)
                propertyModel.imageView.frame = CGRect(x: propertyModel.titleLabel.frame.maxX + propertyModel.tagContentPadding, y: imageY, width: propertyModel.imageWidth, height: propertyModel.imageHeight)
            }
            
            if showLine >= currentLine {
                showLineDataSource.append(propertyModel)
            }
            
            let nextTagX = tagX + tagW + minimumInteritemSpacing
            
            switch scrollDirection {
            case .vertical:
                if index < dealDataSource.count - 1 {
                    let nextIndex = index + 1
                    let nextPropertyModel = dealDataSource[nextIndex]
                    nextTagW = tagWidth(nextPropertyModel)
                }
                if nextTagX + nextTagW + tagsViewContentInset.right > tagsViewWidth {
                    currentLine = currentLine + 1
                    tagX = tagsViewContentInset.left
                    
                    let subDealDataSource = dealDataSource[0...index]
                    let maxYModel = subDealDataSource.max { (m1, m2) -> Bool in
                       return m1.contentView.frame.maxY < m2.contentView.frame.maxY
                    }
                    
                    let lastObjFrame = maxYModel!.contentView.frame
                    tagY = lastObjFrame.maxY + minimumLineSpacing
                }else {
                    tagX = nextTagX
                }
            case .horizontal:
                tagX = nextTagX
            }
        }
        
        if showLineDataSource.count == dealDataSource.count {
            arrowImageView.isHidden = true
        }
       
        var sumHeight = tagsViewMinHeight
        var scrollContentSize = CGSize.zero
        var viewContentSize = CGSize(width: tagsViewWidth, height: sumHeight)
        
        switch scrollDirection {
        case .vertical:
        
            if dealDataSource.count != 0 {
                var lastPropertyModel: TagsPropertyModel!
                
                if showLine > 0 && isSelect == false {
                    lastPropertyModel = filterMaxYModel(dataSource: showLineDataSource, standardModel: showLineDataSource.last!)
                }else {
                    lastPropertyModel = filterMaxYModel(dataSource: dealDataSource, standardModel: dealDataSource.last!)
                }
                
                sumHeight = lastPropertyModel!.contentView.frame.maxY + tagsViewContentInset.bottom
                scrollContentSize = CGSize(width: tagsViewWidth, height: sumHeight)
                sumHeight = sumHeight > tagsViewMaxHeight ? tagsViewMaxHeight : sumHeight
                viewContentSize = CGSize(width: tagsViewWidth, height: sumHeight)
                
                currentOffent = CGSize(width: (selectModel.contentView.frame.minX - minimumLineSpacing) , height: selectModel.contentView.frame.minY - minimumLineSpacing )
            }
        case .horizontal:
            
            if dealDataSource.count != 0 {
                let lastPropertyModel = filterMaxYModel(dataSource: dealDataSource, standardModel: dealDataSource.last!)
                let sumWidth = lastPropertyModel.contentView.frame.maxX + tagsViewContentInset.right
                sumHeight = lastPropertyModel.contentView.frame.maxY + tagsViewContentInset.bottom
                
                scrollContentSize = CGSize(width: sumWidth, height: sumHeight)
                viewContentSize = scrollContentSize
                
                currentOffent = CGSize(width: (selectModel.contentView.frame.minX - minimumLineSpacing) , height: selectModel.contentView.frame.minY - minimumLineSpacing)
            }
        }
        
        frame.size.height = sumHeight
        scrollView.frame = CGRect(x: 0, y: 0, width: tagsViewWidth, height: sumHeight)
        scrollView.contentSize = scrollContentSize;
        
        if (!contentSize.equalTo(viewContentSize)) {
            contentSize = viewContentSize;
            invalidateIntrinsicContentSize()
        }
        
        tagsViewDelegate?.tagsViewUpdateHeight?(self, sumHeight: sumHeight)
        
    }
    
    public override var intrinsicContentSize: CGSize {
       return contentSize
    }
}

  //MARK: -- private
extension Go23TagsView {
    
    private func config() {
        
         dealDataSource.removeAll()
         scrollView.subviews.forEach {  $0.removeFromSuperview() }
        
        if dataSource.count > 0 {
            for (index, value) in dataSource.enumerated() {
                let propertyModel = TagsPropertyModel()
                propertyModel.titleLabel.text = value
                if let d = tagsViewDelegate  {
                    d.tagsViewUpdatePropertyModel?(self, item: propertyModel, index: index)
                }
                scrollView.addSubview(propertyModel.contentView)
                dealDataSource.append(propertyModel)
            }
        }else {
            for (index,item) in modelDataSource.enumerated() {
                if let d = tagsViewDelegate  {
                    d.tagsViewUpdatePropertyModel?(self, item: item, index: index)
                }
                scrollView.addSubview(item.contentView)
                dealDataSource.append(item)
            }
        }
    
     }

    private func tagWidth(_ model: TagsPropertyModel) -> CGFloat {
        let w = ceil(sizeWidthText(model).width) + 0.5 + model.contentInset.left + model.contentInset.right + model.tagContentPadding + model.imageWidth
        return w
    }
    
    private func sizeWidthText(_ model: TagsPropertyModel) -> CGSize {
        return model.titleLabel.text?.size(withAttributes: [.font : model.titleLabel.font!]) ?? CGSize.zero
    }
    
    private func tagHeight(_ model: TagsPropertyModel, width: CGFloat) -> CGFloat {
        let size = model.titleLabel.text?.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options:[.usesLineFragmentOrigin,.usesFontLeading,.truncatesLastVisibleLine], attributes: [.font : model.titleLabel.font!], context: nil)
        return ceil(size?.height ?? 0.0)
    }
    
    // filter  - result return maxYModel
    private func filterMaxYModel(dataSource:[TagsPropertyModel],standardModel:TagsPropertyModel) -> TagsPropertyModel {
        let maxYModel = dataSource.filter { (m) -> Bool in
            m.contentView.frame.minY == standardModel.contentView.frame.minY
         }.max { (m1, m2) -> Bool in
            m1.contentView.frame.maxY <= m2.contentView.frame.maxY
         }
        return maxYModel!
    }
}

//MARK: -- action
extension Go23TagsView {
    @objc func contentViewTapAction(gestureRecongizer: UIGestureRecognizer) {
        let int = gestureRecongizer.view?.tag ?? 0
        if let d = tagsViewDelegate {
            let item = dealDataSource[int];
            item.isSelected = !item.isSelected
            d.tagsViewItemTapAction?(self, item: dealDataSource[int], index: int)
        }
    }
    
    @objc func tagsViewTapAction() {
        tagsViewDelegate?.tagsViewTapAction?(self)
    }
}

public class TagsPropertyModel: NSObject {
    
    public enum TagImageViewAlignmentMode {
        case right
        case left
    }
    
    public var normalImage:UIImage? {
        willSet {
            if selectIedImage == nil { selectIedImage = newValue }
            if isSelected == false { imageView.image = newValue }
        }
    }
    public var selectIedImage:UIImage? {
        willSet {
            if isSelected == true { imageView.image = newValue }
        }
    }
    public var imageSize: CGSize {
        willSet {
            imageView.frame.size = newValue
        }
    }
    public var isSelected: Bool = false {
        willSet {
            imageView.image = newValue ? selectIedImage : normalImage
        }
    }
    public var contentPadding: CGFloat = 8.0
    public var minHeight: CGFloat = 0.0
    public var contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    public var contentView = UIView()
    public var titleLabel = UILabel()
    public var imageAlignmentMode : TagImageViewAlignmentMode = .right
    
    fileprivate var imageView = UIImageView()
    
    fileprivate var imageWidth: CGFloat {
        guard let imageW = imageView.image?.size.width else {
            return 0.0
        }
        if imageView.frame != CGRect.zero, imageView.image != nil {
            return imageView.frame.width
        }
        return imageW
    }
    fileprivate var imageHeight: CGFloat {
        guard let imageH = imageView.image?.size.height else {
            return 0.0
        }
        if imageView.frame != CGRect.zero, imageView.image != nil {
            return imageView.frame.height
        }
        return imageH
    }
    fileprivate var tagContentPadding: CGFloat {
        get {
            return imageWidth > 0.0 ? contentPadding : 0.0
        }
    }
    public override init() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.backgroundColor = .darkGray
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 5
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        titleLabel.text = ""
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        imageSize = CGSize.zero
        super.init()
    }
}

