//
//  Go23TokenDetailListViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/6.
//

import UIKit
import Go23SDK

class Go23TokenDetailListViewController: UIViewController {
    
    
    var model: Go23WalletTokenModel?
    var activityType: Go23ActivityFilterType? {
        didSet {
            self.noDataV.isHidden = true
        }
    }
     
    private var listModel = [Go23ActivityModel]()
    
    private var pageIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubviews()
        getList()
    }
    
    private func initSubviews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        tableView.addSubview(noDataV)
        noDataV.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        noDataV.isHidden = true
        
        tableView.es.addPullToRefresh {
            [weak self] in
            //            self?.tableView.es.stopPullToRefresh()
            NotificationCenter.default.post(name: NSNotification.Name(kRefreshTokenListDetailKey),
                                            object: nil,
                                            userInfo: nil)
            self?.pageIndex = 1
            self?.getList(isLoading: false)
        }
        
        tableView.es.addInfiniteScrolling {
            [weak self] in
            NotificationCenter.default.post(name: NSNotification.Name(kRefreshTokenListDetailKey),
                                            object: nil,
                                            userInfo: nil)
            self?.pageIndex += 1
            self?.getList(isLoading: false)
            
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(Go23TokenDetailTableViewCell.self, forCellReuseIdentifier: Go23TokenDetailTableViewCell.reuseIdentifier())

        return tableView
    }()
    
    
    private lazy var noDataV: UIView = {
        let view = UIView()
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "nodata")
        view.addSubview(imgv)
        imgv.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        let label = UILabel()
        label.text = "No transaction records"
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


extension Go23TokenDetailListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Go23TokenDetailTableViewCell.reuseIdentifier(), for: indexPath) as? Go23TokenDetailTableViewCell,
                indexPath.row < listModel.count
        else {
                return UITableViewCell()
            }
            
        let model = listModel[indexPath.row]
        cell.filled(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Go23TokenDetailTableViewCell.cellHeight

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = Go23TokenDetailResultViewController()
        if indexPath.row < listModel.count {
            vc.hashStr = listModel[indexPath.row].hash
        }
        vc.isPopRoot = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



 //MARK: - pragma mark =========== JXSegmentedListContainerViewListDelegate ===========
extension Go23TokenDetailListViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension Go23TokenDetailListViewController {
    private func getList(isLoading: Bool = true) {
        guard let shared = Go23WalletSDK.shared else {
            return
        }
        guard let obj = self.model else {
            return
        }
        if isLoading {
            Go23Loading.loading()
        }
        shared.getActivityList(with: Go23WalletMangager.shared.walletModel?.chainId ?? 0, contract: obj.contractAddr, walletAddress: Go23WalletMangager.shared.address, type: self.activityType ?? .all, pageNumber: self.pageIndex, pageSize: 10) {  [weak self]model in
            if isLoading {
                Go23Loading.clear()
            }
            if self?.pageIndex ?? 1 > 1 {
                self?.tableView.es.stopLoadingMore()
            } else {
                self?.tableView.es.stopPullToRefresh()
            }
            guard let mm = model else {
                self?.noDataV.isHidden = false
                return
            }
            if self?.pageIndex ?? 1 > 1 {
                self?.listModel += mm.listModel
            } else {
                self?.listModel.removeAll()
                self?.listModel = mm.listModel
            }
            
             if let list = self?.listModel, list.count > 0 {
                 self?.noDataV.isHidden = true
            } else {
                self?.noDataV.isHidden = false
            }
            self?.tableView.reloadData()
        }
        
    }
}
