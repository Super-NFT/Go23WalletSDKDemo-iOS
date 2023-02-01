//
//  Go23DappViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/31.
//

import UIKit

class Go23DappViewController: UIViewController {

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
        setNav()
        initSubviews()
    }
    
    private func setNav() {
        
        if self.navgationBar == nil {
            addBarView()
            navgationBar?.title = "Dapp"
            navgationBar?.attributes = [NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 20), NSAttributedString.Key.kern: 0.5] as [NSAttributedString.Key : Any]
        }
    }
    
    
    private func initSubviews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        scrollView.snp.makeConstraints { make in

            make.top.equalTo(navgationBar!.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        scrollContentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(ScreenWidth)
            make.height.equalTo(ScreenHeight)
            make.centerX.equalToSuperview()
        }
    }
    
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentSize = CGSize(width: 0, height: ScreenHeight)
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()
    
    private lazy var scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    


}
