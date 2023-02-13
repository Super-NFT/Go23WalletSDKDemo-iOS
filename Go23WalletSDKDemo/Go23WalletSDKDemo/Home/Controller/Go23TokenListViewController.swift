//
//  Go23TokenListViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/4.
//

import UIKit
import Go23SDK


class Go23TokenListViewController: UIViewController {

    
    var tokenList: [Go23WalletTokenModel]? {
        didSet {
            guard let list = tokenList else {
                return
            }
            if list.count == 0 {
                noDataV.isHidden = false
            } else {
                noDataV.isHidden = true
            }
            tableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
//        self.getUserTokens()
//        tableView.es.addPullToRefresh { [weak self] in
//            NotificationCenter.default.post(name: NSNotification.Name(kRefreshWalletBalance),
//                                            object: nil,
//                                            userInfo: nil)
//            self?.getUserTokens()
//        }
        
        tableView.addSubview(noDataV)
        noDataV.snp.makeConstraints { make in
            make.top.equalTo(180 * Go23_Scale)
            make.centerX.equalToSuperview()
        }
    }
    
    
     lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(Go23TokenListTableViewCell.self, forCellReuseIdentifier: Go23TokenListTableViewCell.reuseIdentifier())


        return tableView
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

extension Go23TokenListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tokenList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Go23TokenListTableViewCell.reuseIdentifier(), for: indexPath) as? Go23TokenListTableViewCell,let count = self.tokenList?.count, indexPath.row < count
        else {
                return UITableViewCell()
            }
        
        if let model = self.tokenList?[indexPath.row] {
            cell.filled(cover: model.imageUrl, title: model.balance, type:model.symbol, money: model.balanceU, sourceImg: model.chainImageUrl, value: model.tokenValue)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Go23TokenListTableViewCell.cellHeight

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let list = self.tokenList, indexPath.row < list.count {
            let model = list[indexPath.row]
            let vc = Go23TokenDetailViewController()
            vc.model = model

            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}


extension Go23TokenListViewController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        self.view
    }
    
    func listScrollView() -> UIScrollView {
        self.tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        
    }
    
    
}


extension Go23TokenListViewController {
     func getUserTokens() {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        
        shared.getWalletTokenList(with: Go23WalletMangager.shared.address, chainId: Go23WalletMangager.shared.walletModel?.chainId ?? 0, pageSize: 10, pageNumber: 1) { [weak self]tokenList in
            self?.tableView.es.stopPullToRefresh()
            guard let list = tokenList?.listModel else {
                return
            }
            
            if list.count == 0 {
                self?.noDataV.isHidden = false
            } else {
                self?.noDataV.isHidden = true
            }
            self?.tokenList?.removeAll()
            self?.tokenList = list
            self?.tableView.reloadData()
        }
        

    }
}

