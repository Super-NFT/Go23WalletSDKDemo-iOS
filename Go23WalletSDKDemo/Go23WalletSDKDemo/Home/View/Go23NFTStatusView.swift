//
//  Go23NFTStatusView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/8.
//

import UIKit

class Go23NFTStatusView: UIView {

    var hashStr = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
        filled(status: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        roundCorners([.topLeft,.topRight], radius: 12)
        
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(closeBtn)
        addSubview(statusImgv)
        addSubview(statusLabel)
        addSubview(tipsLabel)
        addSubview(gotBtn)
        addSubview(cancelBtn)
        addSubview(signBtn)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        closeBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-6)
            make.width.height.equalTo(44)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        statusImgv.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(65)
            make.width.equalTo(58)
            make.height.equalTo(58)
            make.centerX.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(statusImgv.snp.bottom).offset(0)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
        }
        
        tipsLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        gotBtn.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(0)
             } else {
                 make.bottom.equalTo(0)
            }
            make.width.equalTo(160)
            make.centerX.equalToSuperview()
            make.height.equalTo(46)
        }
        
        cancelBtn.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
             } else {
                 make.bottom.equalTo(0)
            }
            make.width.equalTo(150)
            make.leading.equalTo(20)
            make.height.equalTo(52)
        }
        signBtn.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
             } else {
                 make.bottom.equalTo(0)
            }
            make.width.equalTo(150)
            make.trailing.equalTo(-20)
            make.height.equalTo(52)
        }
    }
    
    func filled(status: Bool) {
        if status {
            statusImgv.image = UIImage.init(named: "waiting")
            statusLabel.text = "Processing..."
            gotBtn.isHidden = true
            cancelBtn.isHidden = false
            signBtn.isHidden = false
        } else {
            statusImgv.image = UIImage.init(named: "failed")
            statusLabel.text = "Failed"
            gotBtn.isHidden = false
            cancelBtn.isHidden = true
            signBtn.isHidden = true
        }
    }
    
    @objc private func closeBtnClick() {
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)
        currentViewController()?.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @objc private func signBtnClick() {
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)
        currentViewController()?.navigationController?.popToRootViewController(animated: true)

    }
    
    @objc private func cancelBtnClick() {
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)
        let vc = Go23NFTDetailResultViewController()
        vc.hashStr = self.hashStr
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)

    }
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "close")
        btn.addSubview(imgv)
        imgv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(15)
        }
        btn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 24), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: "Transaction Result")
        return label
    }()
    
    private lazy var statusImgv: UIImageView = {
        let imgv = UIImageView()
        imgv.image = UIImage(named: "success")
        return imgv
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 24)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#000000")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var gotBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Got it", for: .normal)
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 24)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var signBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        btn.setTitle("Confirm", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 24)
        btn.addTarget(self, action: #selector(signBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        btn.setTitle("View Details", for: .normal)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#00D6E1"), for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 8
        btn.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1").cgColor
        btn.layer.borderWidth = 1
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 24)
        btn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        return btn
    }()
    
}
