//
//  Go23NFTListViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/4.
//

import UIKit
import Go23SDK

class Go23NFTListViewController: UIViewController {

    var nftList: [Go23WalletNFTModel]? {
        didSet {
            guard let list = nftList else {
                return
            }
            if list.count == 0 {
                noDataV.isHidden = false
            } else {
                noDataV.isHidden = true
            }
            collectionView.reloadData()
        }
        
    }
    
    var moreDataBlock: ((_ list: [Go23WalletNFTModel]?)->())?
    var nftIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
//        self.getUserNFTs()
//
//        collectionView.es.addPullToRefresh {
//            [weak self] in
//                NotificationCenter.default.post(name: NSNotification.Name(kRefreshWalletBalance),
//                                                object: nil,
//                                                userInfo: nil)
//                self?.getUserNFTs()
//        }
        
        collectionView.addSubview(noDataV)
        noDataV.snp.makeConstraints { make in
            make.top.equalTo(180 * Go23_Scale)
            make.centerX.equalToSuperview()
        }
        
        collectionView.es.addInfiniteScrolling { [weak self] in
            self?.nftIndex += 1
            self?.getUserNFTs()
        }
    }
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: 20, left: 20, bottom: 0, right: 20)
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        return flowLayout
    }()
     lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: self.flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.register(Go23NFTListCollectionViewCell.self, forCellWithReuseIdentifier: Go23NFTListCollectionViewCell.reuseIdentifier())
        return collectionView
    }()
    
    lazy var noDataV: UIView = {
        let view = UIView()
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "nodata")
        view.addSubview(imgv)
        imgv.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        let label = UILabel()
        label.text = "No records"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .center
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        view.isHidden = true
        return view
    }()

}

// MARK: - pragma mark =========== UICollectionViewDelegate ===========

extension Go23NFTListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.nftList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Go23NFTListCollectionViewCell.reuseIdentifier(), for: indexPath) as? Go23NFTListCollectionViewCell, let list = nftList, indexPath.item < list.count else {
            return UICollectionViewCell()
        }

        if let model = self.nftList?[indexPath.item] {
            cell.filled(cover: model.image, title: model.name,num: model.value)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (ScreenWidth-40-8)/2.0, height: (ScreenWidth-40-8)/2.0 + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let list = self.nftList, indexPath.item < list.count else {
            return
        }
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = Go23NFTDetailViewController()
        vc.nftModel = list[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
    }
}

// MARK: - pragma mark =========== JXSegmentedListContainerViewListDelegate ===========
//extension Go23NFTListViewController: JXSegmentedListContainerViewListDelegate {
//    func listView() -> UIView {
//        return view
//    }
//}

extension Go23NFTListViewController: JXPagingViewListViewDelegate {
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        
    }
    
    public func listView() -> UIView {
        return self.view
    }
    

    public func listScrollView() -> UIScrollView {
        return self.collectionView
    }
}

extension Go23NFTListViewController {
     func getUserNFTs() {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        
         shared.getNftList(with: Go23WalletMangager.shared.address, chainId: Go23WalletMangager.shared.walletModel?.chainId ?? 0, pageSize: 20, pageNumber: self.nftIndex) {  [weak self]model in
            self?.collectionView.es.stopLoadingMore()
            guard let obj = model else {
                return
            }
            if obj.listModel.count == 0 {
                self?.noDataV.isHidden = false
            } else {
                self?.noDataV.isHidden = true
            }
             if let _ = self?.nftList {
                 self?.nftList! += obj.listModel
             }
             self?.moreDataBlock?(self?.nftList)
            self?.collectionView.reloadData()
        }
        
        
    }
        
}
