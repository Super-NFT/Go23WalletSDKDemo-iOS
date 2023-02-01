//
//  Go23MeViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/31.
//

import UIKit

class Go23MeViewController: UIViewController {

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
            navgationBar?.title = "Me"
            navgationBar?.attributes = [NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 20), NSAttributedString.Key.kern: 0.5] as [NSAttributedString.Key : Any]
        }
    }
    
    
    private func initSubviews() {
        view.backgroundColor = .white
    }

}
