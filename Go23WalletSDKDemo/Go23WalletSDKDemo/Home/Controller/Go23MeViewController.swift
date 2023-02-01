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
//        setNav()
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
        view.addSubview(emailTxt)
        view.addSubview(emailV)
        emailV.addSubview(emailLabel)
        emailTxt.snp.makeConstraints { make in
            make.top.equalTo(44)
            make.left.equalTo(20)
            make.height.equalTo(20)
        }
        emailV.snp.makeConstraints { make in
            make.top.equalTo(emailTxt.snp.bottom).offset(5)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
        }
        emailLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        emailLabel.text = Go23WalletMangager.shared.email
    }
    
    private lazy var emailTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.text = "Email"
        return label
    }()
    
    private lazy var emailV: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F8F8F8")
        return view
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#595959")
        return label
    }()

}
