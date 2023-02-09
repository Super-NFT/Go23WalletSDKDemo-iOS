//
//  JXPagingListRefreshView.swift
//  JXPagingView
//
//  Created by jiaxin on 2018/8/28.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

import UIKit

class JXPagingListRefreshView: JXPagingView {
    private var lastScrollingListViewContentOffsetY: CGFloat = 0

    override init(delegate: JXPagingViewDelegate, listContainerType: JXPagingListContainerType = .collectionView) {
        super.init(delegate: delegate, listContainerType: listContainerType)

        mainTableView.bounces = false
    }

    override func preferredProcessMainTableViewDidScroll(_ scrollView: UIScrollView) {
        if pinSectionHeaderVerticalOffset != 0 {
            if !(currentScrollingListView != nil && currentScrollingListView!.contentOffset.y > minContentOffsetYInListScrollView(currentScrollingListView!)) {
                if scrollView.contentOffset.y <= 0 {
                    mainTableView.bounces = false
                    mainTableView.contentOffset = CGPoint.zero
                    return
                }else {
                    mainTableView.bounces = true
                }
            }
        }
        guard let currentScrollingListView = currentScrollingListView else { return }
        if (currentScrollingListView.contentOffset.y > minContentOffsetYInListScrollView(currentScrollingListView)) {
            setMainTableViewToMaxContentOffsetY()
        }

        if (mainTableView.contentOffset.y < mainTableViewMaxContentOffsetY()) {
            for list in validListDict.values {
                if list.listScrollView().contentOffset.y > minContentOffsetYInListScrollView(list.listScrollView()) {
                    setListScrollViewToMinContentOffsetY(list.listScrollView())
                }
            }
        }

        if scrollView.contentOffset.y > mainTableViewMaxContentOffsetY() && currentScrollingListView.contentOffset.y == minContentOffsetYInListScrollView(currentScrollingListView) {
            setMainTableViewToMaxContentOffsetY()
        }
    }
    
    override func preferredProcessListViewDidScroll(scrollView: UIScrollView) {
        guard let currentScrollingListView = currentScrollingListView else { return }
        var shouldProcess = true
        if currentScrollingListView.contentOffset.y > lastScrollingListViewContentOffsetY {
            
        }else {
            
            if mainTableView.contentOffset.y == 0 {
                shouldProcess = false
            }else {
                if (mainTableView.contentOffset.y < mainTableViewMaxContentOffsetY()) {
                    setListScrollViewToMinContentOffsetY(currentScrollingListView)
                    currentScrollingListView.showsVerticalScrollIndicator = false;
                }
            }
        }
        if shouldProcess {
            if (mainTableView.contentOffset.y < mainTableViewMaxContentOffsetY()) {
                if currentScrollingListView.contentOffset.y > minContentOffsetYInListScrollView(currentScrollingListView) {
                    setListScrollViewToMinContentOffsetY(currentScrollingListView)
                    currentScrollingListView.showsVerticalScrollIndicator = false;
                }
            } else {
                setMainTableViewToMaxContentOffsetY()
                currentScrollingListView.showsVerticalScrollIndicator = true;
            }
        }
        lastScrollingListViewContentOffsetY = currentScrollingListView.contentOffset.y;
    }

}
