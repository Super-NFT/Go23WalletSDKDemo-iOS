//
//  JXSegmentedListContainerView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit


public enum JXSegmentedListContainerType {
    case scrollView
    case collectionView
}

@objc
public protocol JXSegmentedListContainerViewListDelegate {

    func listView() -> UIView
    @objc optional func listWillAppear()
    @objc optional func listDidAppear()
    @objc optional func listWillDisappear()
    @objc optional func listDidDisappear()
}

@objc
public protocol JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate


    @objc optional func listContainerView(_ listContainerView: JXSegmentedListContainerView, canInitListAt index: Int) -> Bool

    @objc optional func scrollViewClass(in listContainerView: JXSegmentedListContainerView) -> AnyClass
}

open class JXSegmentedListContainerView: UIView, JXSegmentedViewListContainer, JXSegmentedViewRTLCompatible {
    open private(set) var type: JXSegmentedListContainerType
    open private(set) weak var dataSource: JXSegmentedListContainerViewDataSource?
    open private(set) var scrollView: UIScrollView!
    open private(set) var validListDict = [Int:JXSegmentedListContainerViewListDelegate]()
    open var initListPercent: CGFloat = 0.01 {
        didSet {
            if initListPercent <= 0 || initListPercent >= 1 {
                assertionFailure("initListPercent in (0,1)")
            }
        }
    }
    open var listCellBackgroundColor: UIColor = .white
    open var defaultSelectedIndex: Int = 0 {
        didSet {
            currentIndex = defaultSelectedIndex
        }
    }
    private var currentIndex: Int = 0
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        if let collectionViewClass = dataSource?.scrollViewClass?(in: self) as? UICollectionView.Type {
            return collectionViewClass.init(frame: CGRect.zero, collectionViewLayout: layout)
        }else {
            return UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        }
    }()
    private lazy var containerVC = JXSegmentedListContainerViewController()
    private var willAppearIndex: Int = -1
    private var willDisappearIndex: Int = -1

    public init(dataSource: JXSegmentedListContainerViewDataSource, type: JXSegmentedListContainerType = .scrollView) {
        self.dataSource = dataSource
        self.type = type
        super.init(frame: CGRect.zero)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func commonInit() {
        containerVC.view.backgroundColor = .clear
        addSubview(containerVC.view)
        containerVC.viewWillAppearClosure = {[weak self] in
            self?.listWillAppear(at: self?.currentIndex ?? 0)
        }
        containerVC.viewDidAppearClosure = {[weak self] in
            self?.listDidAppear(at: self?.currentIndex ?? 0)
        }
        containerVC.viewWillDisappearClosure = {[weak self] in
            self?.listWillDisappear(at: self?.currentIndex ?? 0)
        }
        containerVC.viewDidDisappearClosure = {[weak self] in
            self?.listDidDisappear(at: self?.currentIndex ?? 0)
        }
        if type == .scrollView {
            if let scrollViewClass = dataSource?.scrollViewClass?(in: self) as? UIScrollView.Type {
                scrollView = scrollViewClass.init()
            }else {
                scrollView = UIScrollView.init()
            }
            scrollView.delegate = self
            scrollView.isPagingEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.scrollsToTop = false
            scrollView.bounces = false
            if #available(iOS 11.0, *) {
                scrollView.contentInsetAdjustmentBehavior = .never
            }
            if segmentedViewShouldRTLLayout() {
                segmentedView(horizontalFlipForView: scrollView)
            }
            containerVC.view.addSubview(scrollView)
        }else if type == .collectionView {
            collectionView.isPagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            collectionView.scrollsToTop = false
            collectionView.bounces = false
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(JXSegmentedRTLCollectionCell.self, forCellWithReuseIdentifier: "cell")
            if #available(iOS 10.0, *) {
                collectionView.isPrefetchingEnabled = false
            }
            if #available(iOS 11.0, *) {
                self.collectionView.contentInsetAdjustmentBehavior = .never
            }
            if segmentedViewShouldRTLLayout() {
                collectionView.semanticContentAttribute = .forceLeftToRight
                segmentedView(horizontalFlipForView: collectionView)
            }
            containerVC.view.addSubview(collectionView)
            scrollView = collectionView
        }
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        var next: UIResponder? = newSuperview
        while next != nil {
            if let vc = next as? UIViewController{
                vc.addChild(containerVC)
                break
            }
            next = next?.next
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        containerVC.view.frame = bounds
        guard let count = dataSource?.numberOfLists(in: self) else {
            return
        }
        if type == .scrollView {
            if scrollView.frame == CGRect.zero || scrollView.bounds.size != bounds.size {
                scrollView.frame = bounds
                scrollView.contentSize = CGSize(width: scrollView.bounds.size.width*CGFloat(count), height: scrollView.bounds.size.height)
                for (index, list) in validListDict {
                    list.listView().frame = CGRect(x: CGFloat(index)*scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
                }
                scrollView.contentOffset = CGPoint(x: CGFloat(currentIndex)*scrollView.bounds.size.width, y: 0)
            }else {
                scrollView.frame = bounds
                scrollView.contentSize = CGSize(width: scrollView.bounds.size.width*CGFloat(count), height: scrollView.bounds.size.height)
            }
        }else {
            if collectionView.frame == CGRect.zero || collectionView.bounds.size != bounds.size {
                collectionView.frame = bounds
                collectionView.collectionViewLayout.invalidateLayout()
                collectionView.setContentOffset(CGPoint(x: CGFloat(currentIndex)*collectionView.bounds.size.width, y: 0), animated: false)
            }else {
                collectionView.frame = bounds
            }
        }
    }

    //MARK: - JXSegmentedViewListContainer

    public func contentScrollView() -> UIScrollView {
           return scrollView
       }

    public func scrolling(from leftIndex: Int, to rightIndex: Int, percent: CGFloat, selectedIndex: Int) {
    }

    open func didClickSelectedItem(at index: Int) {
        guard checkIndexValid(index) else {
            return
        }
        willAppearIndex = -1
        willDisappearIndex = -1
        if currentIndex != index {
            listWillDisappear(at: currentIndex)
            listWillAppear(at: index)
            listDidDisappear(at: currentIndex)
            listDidAppear(at: index)
        }
    }

    open func reloadData() {
        guard let dataSource = dataSource else { return }
        if currentIndex < 0 || currentIndex >= dataSource.numberOfLists(in: self) {
            defaultSelectedIndex = 0
            currentIndex = 0
        }
        validListDict.values.forEach { (list) in
            if let listVC = list as? UIViewController {
                listVC.removeFromParent()
            }
            list.listView().removeFromSuperview()
        }
        validListDict.removeAll()
        if type == .scrollView {
            scrollView.contentSize = CGSize(width: scrollView.bounds.size.width*CGFloat(dataSource.numberOfLists(in: self)), height: scrollView.bounds.size.height)
        }else {
            collectionView.reloadData()
        }
        listWillAppear(at: currentIndex)
        listDidAppear(at: currentIndex)
    }

    //MARK: - Private
    func initListIfNeeded(at index: Int) {
        guard let dataSource = dataSource else { return }
        if dataSource.listContainerView?(self, canInitListAt: index) == false {
            return
        }
        var existedList = validListDict[index]
        if existedList != nil {
            return
        }
        existedList = dataSource.listContainerView(self, initListAt: index)
        guard let list = existedList else {
            return
        }
        if let vc = list as? UIViewController {
            containerVC.addChild(vc)
        }
        validListDict[index] = list
        if type == .scrollView {
            list.listView().frame = CGRect(x: CGFloat(index)*scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
            scrollView.addSubview(list.listView())
            
            if segmentedViewShouldRTLLayout() {
                segmentedView(horizontalFlipForView: list.listView())
            }
        }else {
            let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0))
            cell?.contentView.subviews.forEach { $0.removeFromSuperview() }
            list.listView().frame = cell?.contentView.bounds ?? CGRect.zero
            cell?.contentView.addSubview(list.listView())
        }
    }

    private func listWillAppear(at index: Int) {
        guard let dataSource = dataSource else { return }
        guard checkIndexValid(index) else {
            return
        }
        var existedList = validListDict[index]
        if existedList != nil {
            existedList?.listWillAppear?()
            if let vc = existedList as? UIViewController {
                vc.beginAppearanceTransition(true, animated: false)
            }
        }else {
            guard dataSource.listContainerView?(self, canInitListAt: index) != false else {
                return
            }
            existedList = dataSource.listContainerView(self, initListAt: index)
            guard let list = existedList else {
                return
            }
            if let vc = list as? UIViewController {
                containerVC.addChild(vc)
            }
            validListDict[index] = list
            if type == .scrollView {
                if list.listView().superview == nil {
                    list.listView().frame = CGRect(x: CGFloat(index)*scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
                    scrollView.addSubview(list.listView())
                    
                    if segmentedViewShouldRTLLayout() {
                        segmentedView(horizontalFlipForView: list.listView())
                    }
                }
                list.listWillAppear?()
                if let vc = list as? UIViewController {
                    vc.beginAppearanceTransition(true, animated: false)
                }
            }else {
                let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0))
                cell?.contentView.subviews.forEach { $0.removeFromSuperview() }
                list.listView().frame = cell?.contentView.bounds ?? CGRect.zero
                cell?.contentView.addSubview(list.listView())
                list.listWillAppear?()
                if let vc = list as? UIViewController {
                    vc.beginAppearanceTransition(true, animated: false)
                }
            }
        }
    }

    private func listDidAppear(at index: Int) {
        guard checkIndexValid(index) else {
            return
        }
        currentIndex = index
        let list = validListDict[index]
        list?.listDidAppear?()
        if let vc = list as? UIViewController {
            vc.endAppearanceTransition()
        }
    }

    private func listWillDisappear(at index: Int) {
        guard checkIndexValid(index) else {
            return
        }
        let list = validListDict[index]
        list?.listWillDisappear?()
        if let vc = list as? UIViewController {
            vc.beginAppearanceTransition(false, animated: false)
        }
    }

    private func listDidDisappear(at index: Int) {
        guard checkIndexValid(index) else {
            return
        }
        let list = validListDict[index]
        list?.listDidDisappear?()
        if let vc = list as? UIViewController {
            vc.endAppearanceTransition()
        }
    }

    private func checkIndexValid(_ index: Int) -> Bool {
        guard let dataSource = dataSource else { return false }
        let count = dataSource.numberOfLists(in: self)
        if count <= 0 || index >= count {
            return false
        }
        return true
    }

    private func listDidAppearOrDisappear(scrollView: UIScrollView) {
        let currentIndexPercent = scrollView.contentOffset.x/scrollView.bounds.size.width
        if willAppearIndex != -1 || willDisappearIndex != -1 {
            let disappearIndex = willDisappearIndex
            let appearIndex = willAppearIndex
            if willAppearIndex > willDisappearIndex {
                if currentIndexPercent >= CGFloat(willAppearIndex) {
                    willDisappearIndex = -1
                    willAppearIndex = -1
                    listDidDisappear(at: disappearIndex)
                    listDidAppear(at: appearIndex)
                }
            }else {
                if currentIndexPercent <= CGFloat(willAppearIndex) {
                    willDisappearIndex = -1
                    willAppearIndex = -1
                    listDidDisappear(at: disappearIndex)
                    listDidAppear(at: appearIndex)
                }
            }
        }
    }
}

extension JXSegmentedListContainerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.numberOfLists(in: self)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = listCellBackgroundColor
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let list = validListDict[indexPath.item]
        if list != nil {
            list?.listView().frame = cell.contentView.bounds
            cell.contentView.addSubview(list!.listView())
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bounds.size
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isTracking || scrollView.isDragging else {
            return
        }
        let percent = scrollView.contentOffset.x/scrollView.bounds.size.width
        let maxCount = Int(round(scrollView.contentSize.width/scrollView.bounds.size.width))
        var leftIndex = Int(floor(Double(percent)))
        leftIndex = max(0, min(maxCount - 1, leftIndex))
        let rightIndex = leftIndex + 1;
        if percent < 0 || rightIndex >= maxCount {
            listDidAppearOrDisappear(scrollView: scrollView)
            return
        }
        let remainderRatio = percent - CGFloat(leftIndex)
        if rightIndex == currentIndex {
            if validListDict[leftIndex] == nil && remainderRatio < (1 - initListPercent) {
                initListIfNeeded(at: leftIndex)
            }else if validListDict[leftIndex] != nil {
                if willAppearIndex == -1 {
                    willAppearIndex = leftIndex;
                    listWillAppear(at: willAppearIndex)
                }
            }

            if willDisappearIndex == -1 {
                willDisappearIndex = rightIndex
                listWillDisappear(at: willDisappearIndex)
            }
        }else {
            if validListDict[rightIndex] == nil && remainderRatio > initListPercent {
                initListIfNeeded(at: rightIndex)
            }else if validListDict[rightIndex] != nil {
                if willAppearIndex == -1 {
                    willAppearIndex = rightIndex
                    listWillAppear(at: willAppearIndex)
                }
            }
            if willDisappearIndex == -1 {
                willDisappearIndex = leftIndex
                listWillDisappear(at: willDisappearIndex)
            }
        }
        listDidAppearOrDisappear(scrollView: scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if willAppearIndex != -1 || willDisappearIndex != -1 {
            listWillDisappear(at: willAppearIndex)
            listWillAppear(at: willDisappearIndex)
            listDidDisappear(at: willAppearIndex)
            listDidAppear(at: willDisappearIndex)
            willDisappearIndex = -1
            willAppearIndex = -1
        }
    }
}

class JXSegmentedListContainerViewController: UIViewController {
    var viewWillAppearClosure: (()->())?
    var viewDidAppearClosure: (()->())?
    var viewWillDisappearClosure: (()->())?
    var viewDidDisappearClosure: (()->())?
    override var shouldAutomaticallyForwardAppearanceMethods: Bool { return false }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearClosure?()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearClosure?()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappearClosure?()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDidDisappearClosure?()
    }
}
