//
//  Go23TokenListViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/4.
//

import UIKit
import MJRefresh
import Go23SDK

class Go23TokenListViewController: UIViewController {

    
    var tokenList: [Go23WalletTokenModel]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.getUserTokens()
        tableView.mj_header = Go23RefreshHeader(refreshingBlock: { [weak self] in
            NotificationCenter.default.post(name: NSNotification.Name(kRefreshWalletBalance),
                                            object: nil,
                                            userInfo: nil)
            
            self?.tokenList?.removeAll()
            self?.getUserTokens()
            
        })
        
        tableView.addSubview(noDataV)
        noDataV.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        noDataV.isHidden = true
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
        
        tableView.register(Go23TokenListTableViewCell.self, forCellReuseIdentifier: Go23TokenListTableViewCell.reuseIdentifier())


        return tableView
    }()
    
    private lazy var noDataV: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "No records"
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
            cell.filled(cover: model.imageUrl, title: model.balance, type:model.symbol, money: model.balanceU, sourceImg: model.chainImageUrl)
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

// MARK: - pragma mark =========== JXSegmentedListContainerViewListDelegate ===========
extension Go23TokenListViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension Go23TokenListViewController {
    private func getUserTokens() {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        
        shared.getWalletTokenList(with: Go23WalletMangager.shared.address, chainId: Go23WalletMangager.shared.walletModel?.chainId ?? 0, pageSize: 10, pageNumber: 1) { [weak self]tokenList in
            self?.tableView.mj_header?.endRefreshing()
            guard let list = tokenList?.listModel else {
                return
            }
            
            if list.count == 0 {
                self?.noDataV.isHidden = false
            } else {
                self?.noDataV.isHidden = true
            }
            self?.tokenList = list
            self?.tableView.reloadData()
        }
        

    }
}


class Go23RefreshHeader: MJRefreshNormalHeader {
    override func prepare() {
        super.prepare()
        self.setTitle("Loading...", for: .refreshing)
        self.setTitle("Release to refresh", for: .pulling)
        self.setTitle("Pull down to refresh", for: .idle)
        self.lastUpdatedTimeLabel?.isHidden = true
    }
}
