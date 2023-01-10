//
//  JXPagingView.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/5/22.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

public protocol JXPagingViewDelegate: NSObjectProtocol {
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int
    func tableHeaderView(in pagingView: JXPagingView) -> UIView
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView
    func numberOfLists(in pagingView: JXPagingView) -> Int
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate

    func pagingView(_ pagingView: JXPagingView, listIdentifierAtIndex index: Int) -> String?
    @available(*, message: "Use pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) method")
    func mainTableViewDidScroll(_ scrollView: UIScrollView)
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView)
    func pagingView(_ pagingView: JXPagingView, mainTableViewWillBeginDragging scrollView: UIScrollView)
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool)
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidEndDecelerating scrollView: UIScrollView)
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidEndScrollingAnimation scrollView: UIScrollView)

    func scrollViewClassInListContainerView(in pagingView: JXPagingView) -> AnyClass?
}

public extension JXPagingViewDelegate {
    func pagingView(_ pagingView: JXPagingView, listIdentifierAtIndex index: Int) -> String? { nil }

    func mainTableViewDidScroll(_ scrollView: UIScrollView) {}
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {}
    func pagingView(_ pagingView: JXPagingView, mainTableViewWillBeginDragging scrollView: UIScrollView) {}
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidEndDragging scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidEndDecelerating scrollView: UIScrollView) {}
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidEndScrollingAnimation scrollView: UIScrollView) {}

    func scrollViewClassInListContainerView(in pagingView: JXPagingView) -> AnyClass? { nil }
}

open class JXPagingView: UIView {
    public var defaultSelectedIndex: Int = 0 {
        didSet {
            listContainerView.defaultSelectedIndex = defaultSelectedIndex
        }
    }
    public private(set) lazy var mainTableView: JXPagingMainTableView = JXPagingMainTableView(frame: CGRect.zero, style: .plain)
    public private(set) lazy var listContainerView: JXPagingListContainerView = JXPagingListContainerView(dataSource: self, type: listContainerType)
    public private(set) var validListDict = [Int:JXPagingViewListViewDelegate]()
    public var pinSectionHeaderVerticalOffset: Int = 0
    public var isListHorizontalScrollEnabled = true {
        didSet {
            listContainerView.scrollView.isScrollEnabled = isListHorizontalScrollEnabled
        }
    }
    public var automaticallyDisplayListVerticalScrollIndicator = true
    public var allowsCacheList: Bool = false
    public private(set) var currentScrollingListView: UIScrollView?
    internal var currentList: JXPagingViewListViewDelegate?
    private var currentIndex: Int = 0
    private weak var delegate: JXPagingViewDelegate?
    private var tableHeaderContainerView: UIView!
    private let cellIdentifier = "cell"
    private let listContainerType: JXPagingListContainerType
    private var listCache = [String:JXPagingViewListViewDelegate]()

    public init(delegate: JXPagingViewDelegate, listContainerType: JXPagingListContainerType = .collectionView) {
        self.delegate = delegate
        self.listContainerType = listContainerType
        super.init(frame: CGRect.zero)

        listContainerView.delegate = self

        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.showsHorizontalScrollIndicator = false
        mainTableView.separatorStyle = .none
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.scrollsToTop = false
        refreshTableHeaderView()
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        if #available(iOS 11.0, *) {
            mainTableView.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 15.0, *) {
            mainTableView.sectionHeaderTopPadding = 0
        }
        addSubview(mainTableView)
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        if mainTableView.frame != bounds {
            mainTableView.frame = bounds
            mainTableView.reloadData()
        }
    }

    open func reloadData() {
        currentList = nil
        currentScrollingListView = nil
        validListDict.removeAll()
        if allowsCacheList, let listCount = delegate?.numberOfLists(in: self) {
            var newListIdentifierArray = [String]()
            for index in 0..<listCount {
                if let listIdentifier = delegate?.pagingView(self, listIdentifierAtIndex: index) {
                    newListIdentifierArray.append(listIdentifier)
                }
            }
            let existedKeys = Array(listCache.keys)
            for listIdentifier in existedKeys {
                if !newListIdentifierArray.contains(listIdentifier) {
                    listCache.removeValue(forKey: listIdentifier)
                }
            }
        }
        refreshTableHeaderView()
        if pinSectionHeaderVerticalOffset != 0 && mainTableView.contentOffset.y > CGFloat(pinSectionHeaderVerticalOffset) {
            mainTableView.contentOffset = .zero
        }
        mainTableView.reloadData()
        listContainerView.reloadData()
    }

    open func resizeTableHeaderViewHeight(animatable: Bool = false, duration: TimeInterval = 0.25, curve: UIView.AnimationCurve = .linear) {
        guard let delegate = delegate else { return }
        if animatable {
            var options: UIView.AnimationOptions = .curveLinear
            switch curve {
            case .easeIn: options = .curveEaseIn
            case .easeOut: options = .curveEaseOut
            case .easeInOut: options = .curveEaseInOut
            default: break
            }
            var bounds = tableHeaderContainerView.bounds
            bounds.size.height = CGFloat(delegate.tableHeaderViewHeight(in: self))
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.tableHeaderContainerView.frame = bounds
                self.mainTableView.tableHeaderView = self.tableHeaderContainerView
                self.mainTableView.setNeedsLayout()
                self.mainTableView.layoutIfNeeded()
            }, completion: nil)
        }else {
            var bounds = tableHeaderContainerView.bounds
            bounds.size.height = CGFloat(delegate.tableHeaderViewHeight(in: self))
            tableHeaderContainerView.frame = bounds
            mainTableView.tableHeaderView = tableHeaderContainerView
        }
    }

    open func preferredProcessListViewDidScroll(scrollView: UIScrollView) {
        if (mainTableView.contentOffset.y < mainTableViewMaxContentOffsetY()) {
            currentList?.listScrollViewWillResetContentOffset()
            setListScrollViewToMinContentOffsetY(scrollView)
            if automaticallyDisplayListVerticalScrollIndicator {
                scrollView.showsVerticalScrollIndicator = false
            }
        } else {
            setMainTableViewToMaxContentOffsetY()
            if automaticallyDisplayListVerticalScrollIndicator {
                scrollView.showsVerticalScrollIndicator = true
            }
        }
    }

    open func preferredProcessMainTableViewDidScroll(_ scrollView: UIScrollView) {
        guard let currentScrollingListView = currentScrollingListView else { return }
        if (currentScrollingListView.contentOffset.y > minContentOffsetYInListScrollView(currentScrollingListView)) {
            setMainTableViewToMaxContentOffsetY()
        }

        if (mainTableView.contentOffset.y < mainTableViewMaxContentOffsetY()) {
            for list in validListDict.values {
                list.listScrollViewWillResetContentOffset()
                setListScrollViewToMinContentOffsetY(list.listScrollView())
            }
        }

        if scrollView.contentOffset.y > mainTableViewMaxContentOffsetY() && currentScrollingListView.contentOffset.y == minContentOffsetYInListScrollView(currentScrollingListView) {
            setMainTableViewToMaxContentOffsetY()
        }
    }

    //MARK: - Private

    func refreshTableHeaderView() {
        guard let delegate = delegate else { return }
        let tableHeaderView = delegate.tableHeaderView(in: self)
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat(delegate.tableHeaderViewHeight(in: self))))
        containerView.addSubview(tableHeaderView)
        tableHeaderView.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: tableHeaderView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: tableHeaderView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: tableHeaderView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: tableHeaderView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0)
        containerView.addConstraints([top, leading, bottom, trailing])
        tableHeaderContainerView = containerView
        mainTableView.tableHeaderView = containerView
    }

    func adjustMainScrollViewToTargetContentInsetIfNeeded(inset: UIEdgeInsets) {
        if mainTableView.contentInset != inset {
            
            mainTableView.delegate = nil
            mainTableView.contentInset = inset
            mainTableView.delegate = self
        }
    }


    func isSetMainScrollViewContentInsetToZeroEnabled(scrollView: UIScrollView) -> Bool {
        return !(scrollView.contentInset.top != 0 && scrollView.contentInset.top != CGFloat(pinSectionHeaderVerticalOffset))
    }

    func mainTableViewMaxContentOffsetY() -> CGFloat {
        guard let delegate = delegate else { return 0 }
        return CGFloat(delegate.tableHeaderViewHeight(in: self)) - CGFloat(pinSectionHeaderVerticalOffset)
    }

    func setMainTableViewToMaxContentOffsetY() {
        mainTableView.contentOffset = CGPoint(x: 0, y: mainTableViewMaxContentOffsetY())
    }

    func minContentOffsetYInListScrollView(_ scrollView: UIScrollView) -> CGFloat {
        if #available(iOS 11.0, *) {
            return -scrollView.adjustedContentInset.top
        }
        return -scrollView.contentInset.top
    }

    func setListScrollViewToMinContentOffsetY(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: minContentOffsetYInListScrollView(scrollView))
    }

    func pinSectionHeaderHeight() -> CGFloat {
        guard let delegate = delegate else { return 0 }
        return CGFloat(delegate.heightForPinSectionHeader(in: self))
    }

    func listViewDidScroll(scrollView: UIScrollView) {
        currentScrollingListView = scrollView
        preferredProcessListViewDidScroll(scrollView: scrollView)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension JXPagingView: UITableViewDataSource, UITableViewDelegate {
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return max(bounds.height - pinSectionHeaderHeight() - CGFloat(pinSectionHeaderVerticalOffset), 0)
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        if listContainerView.superview != cell.contentView {
            cell.contentView.addSubview(listContainerView)
        }
        if listContainerView.frame != cell.bounds {
            listContainerView.frame = cell.bounds
        }
        return cell
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return pinSectionHeaderHeight()
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let delegate = delegate else { return nil }
        return delegate.viewForPinSectionHeader(in: self)
    }

    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect.zero)
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if pinSectionHeaderVerticalOffset != 0 {
            if !(currentScrollingListView != nil && currentScrollingListView!.contentOffset.y > minContentOffsetYInListScrollView(currentScrollingListView!)) {
                if scrollView.contentOffset.y >= CGFloat(pinSectionHeaderVerticalOffset) {
                   adjustMainScrollViewToTargetContentInsetIfNeeded(inset: UIEdgeInsets(top: CGFloat(pinSectionHeaderVerticalOffset), left: 0, bottom: 0, right: 0))
                }else {
                    if isSetMainScrollViewContentInsetToZeroEnabled(scrollView: scrollView) {
                        adjustMainScrollViewToTargetContentInsetIfNeeded(inset: UIEdgeInsets.zero)
                    }
                }
            }
        }
        preferredProcessMainTableViewDidScroll(scrollView)
        delegate?.mainTableViewDidScroll(scrollView)
        delegate?.pagingView(self, mainTableViewDidScroll: scrollView)
    }

    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        listContainerView.scrollView.isScrollEnabled = false
        delegate?.pagingView(self, mainTableViewWillBeginDragging: scrollView)
    }

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isListHorizontalScrollEnabled && !decelerate {
            listContainerView.scrollView.isScrollEnabled = true
        }
        delegate?.pagingView(self, mainTableViewDidEndDragging: scrollView, willDecelerate: decelerate)
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isListHorizontalScrollEnabled {
            listContainerView.scrollView.isScrollEnabled = true
        }
        if isSetMainScrollViewContentInsetToZeroEnabled(scrollView: scrollView) {
            if mainTableView.contentInset.top != 0 && pinSectionHeaderVerticalOffset != 0 {
                adjustMainScrollViewToTargetContentInsetIfNeeded(inset: UIEdgeInsets.zero)
            }
        }
        delegate?.pagingView(self, mainTableViewDidEndDecelerating: scrollView)
    }

    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if isListHorizontalScrollEnabled {
            listContainerView.scrollView.isScrollEnabled = true
        }
        delegate?.pagingView(self, mainTableViewDidEndScrollingAnimation: scrollView)
    }
}

extension JXPagingView: JXPagingListContainerViewDataSource {
    public func numberOfLists(in listContainerView: JXPagingListContainerView) -> Int {
        guard let delegate = delegate else { return 0 }
        return delegate.numberOfLists(in: self)
    }

    public func listContainerView(_ listContainerView: JXPagingListContainerView, initListAt index: Int) -> JXPagingViewListViewDelegate {
        guard let delegate = delegate else { fatalError("JXPaingView.delegate must not be nil") }
        var list = validListDict[index]
        if allowsCacheList, list == nil, let listIdentifier = delegate.pagingView(self, listIdentifierAtIndex: index) {
            list = listCache[listIdentifier]
        }
        if list == nil {
            list = delegate.pagingView(self, initListAtIndex: index)
            list?.listViewDidScrollCallback {[weak self, weak list] (scrollView) in
                self?.currentList = list
                self?.listViewDidScroll(scrollView: scrollView)
            }
            validListDict[index] = list!
            if allowsCacheList, let listIdentifier = delegate.pagingView(self, listIdentifierAtIndex: index) {
                listCache[listIdentifier] = list
            }
        }
        return list!
    }

    public func scrollViewClass(in listContainerView: JXPagingListContainerView) -> AnyClass? {
        return delegate?.scrollViewClassInListContainerView(in: self) ?? UIView.self
    }
}

extension JXPagingView: JXPagingListContainerViewDelegate {
    public func listContainerViewWillBeginDragging(_ listContainerView: JXPagingListContainerView) {
        mainTableView.isScrollEnabled = false
    }

    public func listContainerViewDidEndScrolling(_ listContainerView: JXPagingListContainerView) {
        mainTableView.isScrollEnabled = true
    }

    public func listContainerView(_ listContainerView: JXPagingListContainerView, listDidAppearAt index: Int) {
        currentScrollingListView = validListDict[index]?.listScrollView()
        for listItem in validListDict.values {
            if listItem === validListDict[index] {
                listItem.listScrollView().scrollsToTop = true
            }else {
                listItem.listScrollView().scrollsToTop = false
            }
        }
    }
}


