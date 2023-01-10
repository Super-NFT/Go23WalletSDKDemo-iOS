//
//  Go23ScanViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/7.
//

import UIKit

class Go23ScanViewController: LBXScanViewController {
    
    
    var qrcodeBlock: ((_ qrcode: String) -> ())?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()

    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubviews()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 20), NSAttributedString.Key.kern: 0.5,NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key : Any]
        if #available(iOS 13.0, *) {
            let style = UINavigationBarAppearance()
            style.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 20), NSAttributedString.Key.kern: 0.5,NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key : Any]
            navigationController?.navigationBar.scrollEdgeAppearance = style
        }

    }
    
    private func setNav() {
        navigationItem.title = "Send"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 20), NSAttributedString.Key.kern: 0.5,NSAttributedString.Key.foregroundColor: UIColor.white] as [NSAttributedString.Key : Any]
        if #available(iOS 13.0, *) {
            let style = UINavigationBarAppearance()
            style.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 20), NSAttributedString.Key.kern: 0.5,NSAttributedString.Key.foregroundColor: UIColor.white] as [NSAttributedString.Key : Any]
            navigationController?.navigationBar.scrollEdgeAppearance = style
        }
        self.navigationController?.navigationBar.backgroundColor = .clear
        let backBtn = UIButton()
        backBtn.frame = CGRectMake(0, 0, 44, 44)
        let imgv = UIImageView()
        backBtn.addSubview(imgv)
        imgv.image = UIImage.init(named: "whiteBack")
        imgv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        backBtn.addTarget(self, action: #selector(backBtnDidClick), for: .touchUpInside)
        
        let rightBtn = UIButton()
        rightBtn.frame = CGRectMake(0, 0, 44, 44)
        rightBtn.setTitle("Album", for: .normal)
        rightBtn.setTitleColor(.white, for: .normal)
        rightBtn.addTarget(self, action: #selector(btnDidClick), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)


    }
    
    private func initSubviews() {
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "scanBg")
        view.addSubview(imgv)
        imgv.snp.makeConstraints { make in
            make.top.equalTo((ScreenHeight-ScreenWidth-60)/2.0)
            make.centerX.equalToSuperview()
            make.width.equalTo((ScreenWidth-120))
            make.height.equalTo(ScreenWidth-120)
        }
        
        let qrCodelLabel = UILabel()
        qrCodelLabel.text = "Scan QR-CODE"
        qrCodelLabel.textColor = .white
        qrCodelLabel.textAlignment = .center
        qrCodelLabel.font = UIFont(name: BarlowCondensed, size: 20)
        view.addSubview(qrCodelLabel)
        qrCodelLabel.snp.makeConstraints { make in
            make.top.equalTo(imgv.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
        }
        let descLabel = UILabel()
        descLabel.text = "Transfer or Connect Wallet"
        descLabel.textColor = .white
        descLabel.textAlignment = .center
        descLabel.font = UIFont(name: NotoSans, size: 14)
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(qrCodelLabel.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
    }
    
    @objc private func backBtnDidClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func btnDidClick() {
        LBXPermissions.authorizePhotoWith { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true, completion: nil)
        }

    }
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {

        for result: LBXScanResult in arrayResult {
            if let str = result.strScanned {
                print("qrcode ======="+str)
                let arr = str.components(separatedBy: ":")
                var qrcode = str
                if arr.count == 2 {
                    qrcode = arr[1]
                }
                
                let arr1 = qrcode.components(separatedBy: "@")
                if arr1.count == 2 {
                    qrcode = arr1[0]
                }
                
                self.qrcodeBlock?(qrcode)
                self.navigationController?.popViewController(animated: true)
            }
        }

    }
    
    
    

}
