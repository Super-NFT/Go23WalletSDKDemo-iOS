//
//  Go23SwapSelectViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/2/21.
//

import UIKit
import Kingfisher
import Go23SDK


class Go23SwapSelectViewController: UIViewController {

    
    var tokenList: [Go23ChainTokenModel]?
    var tokenIndex = 1

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
//        getUserTokens()
//        
//        tableView.es.addPullToRefresh {[weak self] in
//            self?.tokenIndex = 1
//            self?.getUserTokens(isLoading: false)
//        }
//        tableView.es.addInfiniteScrolling { [weak self] in
//            self?.tokenIndex += 1
//            self?.getUserTokens(isLoading: false)
//        }

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
        tableView.register(SwapTokenViewCell.self, forCellReuseIdentifier: SwapTokenViewCell.reuseIdentifier())

        return tableView
    }()
    

}


extension Go23SwapSelectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tokenList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddTokenViewCell.reuseIdentifier(), for: indexPath) as? AddTokenViewCell, let count = self.tokenList?.count,indexPath.row < count
        else {
            return UITableViewCell()
        }
        
        if let model = self.tokenList?[indexPath.row] {
            cell.filled(model: model, isHidden: indexPath.row == 0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Go23ChooseAlertViewCell.cellHeight
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let count = self.tokenList?.count, indexPath.row < count {
            
        }
        
        if let count = self.tokenList?.count, indexPath.row < count,let model = self.tokenList?[indexPath.row]{
//
            if model.isPlatform {
                return
            }
            
            if model.isSelected {
                hideToken(model: model)
                return
            }
            addToken(model: model)
            
        }
    }
    
}
    
    
    



extension Go23SwapSelectViewController {
    @objc private func getUserTokens(isLoading: Bool = true) {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        
       guard let walletObj = Go23WalletMangager.shared.walletModel else {
           return
           
       }
        if isLoading {
            Go23Loading.loading()
        }
       
       shared.getChainTokenList(with: walletObj.chainId, pageSize: 20, pageNumber: self.tokenIndex) { [weak self] model in
           self?.tableView.es.stopPullToRefresh()
           self?.tableView.es.stopLoadingMore()
           if isLoading {
               Go23Loading.clear()
           }
           if self?.tokenIndex ?? 1 > 1 {
               if let _ = self?.tokenList, let _ = model?.listModel {
                   self?.tokenList! += model!.listModel
               }
           } else {
               self?.tokenList?.removeAll()
               self?.tokenList = model?.listModel
           }
           
           self?.tableView.reloadData()
       }
        
    }
    
    func hideToken(model: Go23ChainTokenModel) {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        
        Go23Loading.loading()
        guard let walletObj = Go23WalletMangager.shared.walletModel else {
        return
        }
        shared.hideToken(with: model.chainId, walletAddress: Go23WalletMangager.shared.address, contractAddress: model.contractAddress) { [weak self](data) in
            print(data)
            Go23Loading.clear()
            self?.getUserTokens()
        }
        

    }
    
    func addToken(model: Go23ChainTokenModel) {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        Go23Loading.loading()
        shared.addToken(with: model.chainId, walletAddress: Go23WalletMangager.shared.address, contractAddress: model.contractAddress) { [weak self](data) in
            Go23Loading.clear()
            self?.getUserTokens()
        }
        
    }
}

//MARK: - pragma mark =========== JXSegmentedListContainerViewListDelegate ===========
extension Go23SwapSelectViewController: JXSegmentedListContainerViewListDelegate {
   func listView() -> UIView {
       return view
   }
}
