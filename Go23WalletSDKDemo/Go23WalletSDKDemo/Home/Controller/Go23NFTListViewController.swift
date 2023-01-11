//
//  Go23NFTListViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/4.
//

import UIKit
import MJRefresh
import MBProgressHUD
import Go23SDK

class Go23NFTListViewController: UIViewController {

    var nftList: [Go23WalletNFTModel]  = [Go23WalletNFTModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        self.getUserNFTs()
        collectionView.mj_header = Go23RefreshHeader(refreshingBlock: { [weak self] in
            NotificationCenter.default.post(name: NSNotification.Name(kRefreshWalletBalance),
                                            object: nil,
                                            userInfo: nil)
            self?.nftList.removeAll()
            self?.getUserNFTs()
        })
        
        collectionView.addSubview(noDataV)
        noDataV.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        noDataV.isHidden = true
    }
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: 20, left: 20, bottom: 0, right: 20)
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        return flowLayout
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: self.flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(Go23NFTListCollectionViewCell.self, forCellWithReuseIdentifier: Go23NFTListCollectionViewCell.reuseIdentifier())
        return collectionView
    }()
    
    private lazy var noDataV: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "No records"
//        label.font = UIFont(name: NotoSans, size: 14)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .center
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return view
    }()

}

// MARK: - pragma mark =========== UICollectionViewDelegate ===========

extension Go23NFTListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.nftList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Go23NFTListCollectionViewCell.reuseIdentifier(), for: indexPath) as? Go23NFTListCollectionViewCell, indexPath.item < nftList.count else {
            return UICollectionViewCell()
        }

        let model = nftList[indexPath.item]
        cell.filled(cover: model.image, title: model.name)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (ScreenWidth-40-8)/2.0, height: (ScreenWidth-40-8)/2.0 + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < nftList.count else {
            return
        }
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = Go23NFTDetailViewController()
        vc.nftModel = nftList[indexPath.item]
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
extension Go23NFTListViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension Go23NFTListViewController {
    private func getUserNFTs() {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        
        shared.getNftList(with: Go23WalletMangager.shared.address, chainId: Go23WalletMangager.shared.walletModel?.chainId ?? 0, pageSize: 10, pageNumber: 1) {  [weak self]model in
            self?.collectionView.mj_header?.endRefreshing()
            guard let obj = model else {
                return
            }
            if obj.listModel.count == 0 {
                self?.noDataV.isHidden = false
            } else {
                self?.noDataV.isHidden = true
            }
            self?.nftList = obj.listModel
            self?.collectionView.reloadData()
        }
        
        
    }
        
}
