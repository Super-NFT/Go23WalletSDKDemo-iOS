//
//  JXPagingListContainerView.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit

enum JXPagingListContainerType {
    case scrollView
    case collectionView
}

protocol JXPagingViewListViewDelegate: NSObjectProtocol {
    func listView() -> UIView
    
    func listScrollView() -> UIScrollView

    func listViewDidScrollCallback(callback: @escaping (UIScrollView)->())

    func listScrollViewWillResetContentOffset()
    func listWillAppear()
    func listDidAppear()
    func listWillDisappear()
    func listDidDisappear()
}

extension JXPagingViewListViewDelegate {
    
    func listScrollViewWillResetContentOffset() {}
    func listWillAppear() {}
    func listDidAppear() {}
    func listWillDisappear() {}
    func listDidDisappear() {}
}

protocol JXPagingListContainerViewDataSource: NSObjectProtocol {

    func numberOfLists(in listContainerView: JXPagingListContainerView) -> Int

    func listContainerView(_ listContainerView: JXPagingListContainerView, initListAt index: Int) -> JXPagingViewListViewDelegate


    func listContainerView(_ listContainerView: JXPagingListContainerView, canInitListAt index: Int) -> Bool

    func scrollViewClass(in listContainerView: JXPagingListContainerView) -> AnyClass?
}

extension JXPagingListContainerViewDataSource {
    func listContainerView(_ listContainerView: JXPagingListContainerView, canInitListAt index: Int) -> Bool { true }
    func scrollViewClass(in listContainerView: JXPagingListContainerView) -> AnyClass? { nil }
}

protocol JXPagingListContainerViewDelegate: NSObjectProtocol {
    func listContainerViewDidScroll(_ listContainerView: JXPagingListContainerView)
    func listContainerViewWillBeginDragging(_ listContainerView: JXPagingListContainerView)
    func listContainerViewDidEndScrolling(_ listContainerView: JXPagingListContainerView)
    func listContainerView(_ listContainerView: JXPagingListContainerView, listDidAppearAt index: Int)
}

extension JXPagingListContainerViewDelegate {
    
    func listContainerViewDidScroll(_ listContainerView: JXPagingListContainerView) {}
    func listContainerViewWillBeginDragging(_ listContainerView: JXPagingListContainerView) {}
    func listContainerViewDidEndScrolling(_ listContainerView: JXPagingListContainerView) {}
    func listContainerView(_ listContainerView: JXPagingListContainerView, listDidAppearAt index: Int) {}
}

class JXPagingListContainerView: UIView {
    private(set) var type: JXPagingListContainerType
    private(set) weak var dataSource: JXPagingListContainerViewDataSource?
    private(set) var scrollView: UIScrollView!
    var isCategoryNestPagingEnabled = false {
        didSet {
            if let containerScrollView = scrollView as? JXPagingListContainerScrollView {
                containerScrollView.isCategoryNestPagingEnabled = isCategoryNestPagingEnabled
            }else if let containerScrollView = scrollView as? JXPagingListContainerCollectionView {
                containerScrollView.isCategoryNestPagingEnabled = isCategoryNestPagingEnabled
            }
        }
    }
    var validListDict = [Int:JXPagingViewListViewDelegate]()
    ///
    var initListPercent: CGFloat = 0.01 {
        didSet {
            if initListPercent <= 0 || initListPercent >= 1 {
                assertionFailure("initListPercent in (0,1)")
            }
        }
    }
    var listCellBackgroundColor: UIColor = .white
 
    var defaultSelectedIndex: Int = 0 {
        didSet {
            currentIndex = defaultSelectedIndex
        }
    }
    weak var delegate: JXPagingListContainerViewDelegate?
    private(set) var currentIndex: Int = 0
    private var collectionView: UICollectionView!
    private var containerVC: JXPagingListContainerViewController!
    private var willAppearIndex: Int = -1
    private var willDisappearIndex: Int = -1

    init(dataSource: JXPagingListContainerViewDataSource, type: JXPagingListContainerType = .collectionView) {
        self.dataSource = dataSource
        self.type = type
        super.init(frame: CGRect.zero)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        guard let dataSource = dataSource else { return }
        containerVC = JXPagingListContainerViewController()
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
            if let scrollViewClass = dataSource.scrollViewClass(in: self) as? UIScrollView.Type {
                scrollView = scrollViewClass.init()
            }else {
                scrollView = JXPagingListContainerScrollView.init()
            }
            scrollView.backgroundColor = .clear
            scrollView.delegate = self
            scrollView.isPagingEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.scrollsToTop = false
            scrollView.bounces = false
            if #available(iOS 11.0, *) {
                scrollView.contentInsetAdjustmentBehavior = .never
            }
            containerVC.view.addSubview(scrollView)
        }else if type == .collectionView {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            if let collectionViewClass = dataSource.scrollViewClass(in: self) as? UICollectionView.Type {
                collectionView = collectionViewClass.init(frame: CGRect.zero, collectionViewLayout: layout)
            }else {
                collectionView = JXPagingListContainerCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
            }
            collectionView.backgroundColor = .clear
            collectionView.isPagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            collectionView.scrollsToTop = false
            collectionView.bounces = false
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            if #available(iOS 10.0, *) {
                collectionView.isPrefetchingEnabled = false
            }
            if #available(iOS 11.0, *) {
                self.collectionView.contentInsetAdjustmentBehavior = .never
            }
            containerVC.view.addSubview(collectionView)
            
            scrollView = collectionView
        }
    }

    override func willMove(toSuperview newSuperview: UIView?) {
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

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let dataSource = dataSource else { return }
        containerVC.view.frame = bounds
        if type == .scrollView {
            if scrollView.frame == CGRect.zero || scrollView.bounds.size != bounds.size {
                scrollView.frame = bounds
                scrollView.contentSize = CGSize(width: scrollView.bounds.size.width*CGFloat(dataSource.numberOfLists(in: self)), height: scrollView.bounds.size.height)
                for (index, list) in validListDict {
                    list.listView().frame = CGRect(x: CGFloat(index)*scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
                }
                scrollView.contentOffset = CGPoint(x: CGFloat(currentIndex)*scrollView.bounds.size.width, y: 0)
            }else {
                scrollView.frame = bounds
                scrollView.contentSize = CGSize(width: scrollView.bounds.size.width*CGFloat(dataSource.numberOfLists(in: self)), height: scrollView.bounds.size.height)
            }
        }else {
            if collectionView.frame == CGRect.zero || collectionView.bounds.size != bounds.size {
                collectionView.frame = bounds
                collectionView.collectionViewLayout.invalidateLayout()
                collectionView.reloadData()
                collectionView.setContentOffset(CGPoint(x: CGFloat(currentIndex)*collectionView.bounds.size.width, y: 0), animated: false)
            }else {
                collectionView.frame = bounds
            }
        }
    }

    //MARK: - JXSegmentedViewListContainer

    func contentScrollView() -> UIScrollView {
           return scrollView
    }

    func scrolling(from leftIndex: Int, to rightIndex: Int, percent: CGFloat, selectedIndex: Int) {
    }

    func didClickSelectedItem(at index: Int) {
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

    func reloadData() {
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
        if dataSource.listContainerView(self, canInitListAt: index) == false {
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
        switch type {
            case .scrollView:
                list.listView().frame = CGRect(x: CGFloat(index)*scrollView.bounds.size.width, y: 0, width: scrollView.bounds.size.width, height: scrollView.bounds.size.height)
                scrollView.addSubview(list.listView())
            case .collectionView:
                if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) {
                    cell.contentView.subviews.forEach { $0.removeFromSuperview() }
                    list.listView().frame = cell.contentView.bounds
                    cell.contentView.addSubview(list.listView())
                }
        }
    }

    private func listWillAppear(at index: Int) {
        guard let dataSource = dataSource else { return }
        guard checkIndexValid(index) else {
            return
        }
        var existedList = validListDict[index]
        if existedList != nil {
            existedList?.listWillAppear()
            if let vc = existedList as? UIViewController {
                vc.beginAppearanceTransition(true, animated: false)
            }
        }else {
            guard dataSource.listContainerView(self, canInitListAt: index) != false else {
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
                }
                list.listWillAppear()
                if let vc = list as? UIViewController {
                    vc.beginAppearanceTransition(true, animated: false)
                }
            }else {
                let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0))
                cell?.contentView.subviews.forEach { $0.removeFromSuperview() }
                list.listView().frame = cell?.contentView.bounds ?? CGRect.zero
                cell?.contentView.addSubview(list.listView())
                list.listWillAppear()
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
        list?.listDidAppear()
        if let vc = list as? UIViewController {
            vc.endAppearanceTransition()
        }
        delegate?.listContainerView(self, listDidAppearAt: index)
    }

    private func listWillDisappear(at index: Int) {
        guard checkIndexValid(index) else {
            return
        }
        let list = validListDict[index]
        list?.listWillDisappear()
        if let vc = list as? UIViewController {
            vc.beginAppearanceTransition(false, animated: false)
        }
    }

    private func listDidDisappear(at index: Int) {
        guard checkIndexValid(index) else {
            return
        }
        let list = validListDict[index]
        list?.listDidDisappear()
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

extension JXPagingListContainerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.numberOfLists(in: self)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = listCellBackgroundColor
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        let list = validListDict[indexPath.item]
        if list != nil {
            if list is UIViewController {
                list?.listView().frame = cell.contentView.bounds
            }else {
                list?.listView().frame = cell.bounds
            }
            cell.contentView.addSubview(list!.listView())
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bounds.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.listContainerViewDidScroll(self)
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

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if willAppearIndex != -1 || willDisappearIndex != -1 {
            listWillDisappear(at: willAppearIndex)
            listWillAppear(at: willDisappearIndex)
            listDidDisappear(at: willAppearIndex)
            listDidAppear(at: willDisappearIndex)
            willDisappearIndex = -1
            willAppearIndex = -1
        }
        delegate?.listContainerViewDidEndScrolling(self)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.listContainerViewWillBeginDragging(self)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            delegate?.listContainerViewDidEndScrolling(self)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.listContainerViewDidEndScrolling(self)
    }
}

class JXPagingListContainerViewController: UIViewController {
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

class JXPagingListContainerScrollView: UIScrollView, UIGestureRecognizerDelegate {
    var isCategoryNestPagingEnabled = false
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if isCategoryNestPagingEnabled, let panGestureClass = NSClassFromString("UIScrollViewPanGestureRecognizer"), gestureRecognizer.isMember(of: panGestureClass) {
            let panGesture = gestureRecognizer as! UIPanGestureRecognizer
            let velocityX = panGesture.velocity(in: panGesture.view!).x
            if velocityX > 0 {
                
                if contentOffset.x == 0 {
                    return false
                }
            }else if velocityX < 0 {
                if contentOffset.x + bounds.size.width == contentSize.width {
                    return false
                }
            }
        }
        return true
    }
}
class JXPagingListContainerCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    var isCategoryNestPagingEnabled = false
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if isCategoryNestPagingEnabled, let panGestureClass = NSClassFromString("UIScrollViewPanGestureRecognizer"), gestureRecognizer.isMember(of: panGestureClass)  {
            let panGesture = gestureRecognizer as! UIPanGestureRecognizer
            let velocityX = panGesture.velocity(in: panGesture.view!).x
            if velocityX > 0 {
                if contentOffset.x == 0 {
                    return false
                }
            }else if velocityX < 0 {
                if contentOffset.x + bounds.size.width == contentSize.width {
                    return false
                }
            }
        }
        return true
    }
}
