//
//  Go23EmailViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/6.
//

import UIKit
import Go23SDK

class Go23EmailViewController: UIViewController {

    var settingType: SettingType = .resharding
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubviews()
            }

    private func initSubviews() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(emailLabel)
        view.addSubview(sendDescLabel)
        view.addSubview(verifyBtn)
        view.addSubview(forgetView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
        }
        
        sendDescLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(90)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        
        verifyBtn.snp.makeConstraints { make in
            make.top.equalTo(sendDescLabel.snp.bottom).offset(10)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(52)
        }
        
        forgetView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        forgetView.isHidden = true
    }
    
    func filled(){
        if Go23WalletMangager.shared.email.count > 0 {
            emailLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: Go23WalletMangager.shared.email)
            sendDescLabel.text = "Send verification email"
        } else {
            emailLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: Go23WalletMangager.shared.phone)
            sendDescLabel.text = "Send verification SMS"
            
        }
        
    }
    
    @objc private func verifyBtnClick() {
        guard let shared = Go23WalletSDK.shared else {
            return
        }
        var str = ""
        if settingType == .recover {
            str = "recover"
        } else {
            str = "reshare"
        }
        
        Go23Loading.loading()
        if Go23WalletMangager.shared.email.count > 0 {
            shared.sendVerifyCode(for: .email(str)) { [weak self]status in
                Go23Loading.clear()
                if status {
                    self?.forgetView.isHidden = false
                    self?.forgetView.codeView.startInput()
                }
            }
        } else {
            shared.sendVerifyCode(for: .phone(str)) { [weak self]status in
                Go23Loading.clear()
                if status {
                    self?.forgetView.isHidden = false
                    self?.forgetView.codeView.startInput()
                }
            }
        }
        
        
    }
    
 
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = String.getAttributeString(font: UIFont.systemFont(ofSize: 14), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#8C8C8C"),alignment: .center, title: "Verify your account")
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 20)
        label.textColor = UIColor.init(named: "#262626")
        label.textAlignment = .center
        return label
    }()

    private lazy var sendDescLabel: UILabel = {
        let label = UILabel()
        label.text = "Send verification email"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .center
        return label
    }()
  
        
    private lazy var verifyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        btn.setTitle("Send", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 24)
        btn.addTarget(self, action: #selector(verifyBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var forgetView: Go23ForgetPwdView = {
        let view = Go23ForgetPwdView()
        view.settingType = settingType
        return view
    }()
    
   

}

//MARK: - pragma mark =========== JXSegmentedListContainerViewListDelegate ===========
extension Go23EmailViewController: JXSegmentedListContainerViewListDelegate {
   func listView() -> UIView {
       return view
   }
}

