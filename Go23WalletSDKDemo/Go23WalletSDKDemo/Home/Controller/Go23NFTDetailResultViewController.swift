//
//  Go23NFTDetailResultViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/15.
//

import UIKit
import MBProgressHUD
import Go23WalletSDK

class Go23NFTDetailResultViewController: UIViewController {
    private var timer: Timer?

    var hashStr = ""
    var detailModel: Go23ActivityDetailModel?
    var hud: MBProgressHUD?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()

    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSubviews()
        getTrasactionDetail()
        creatTimer()
    }
    
    deinit {
        removeTimer()
    }
    
    private func creatTimer() {
        self.timer = Timer(timeInterval: 3.0, repeats: true) { [weak self] timer in
            
            guard let obj = self?.detailModel else {
                return
                
            }
            if obj.status == 1 {
                self?.getTrasactionDetail(isLoading: false)
            } else {
                self?.removeTimer()
            }
        }
        guard let timer = self.timer else {
            return
        }
        RunLoop.current.add(timer, forMode: .common)
        
    }
    
    private func removeTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func setNav() {
        navigationItem.title = "Details"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 20), NSAttributedString.Key.kern: 0.5] as [NSAttributedString.Key : Any]
        if #available(iOS 13.0, *) {
            let style = UINavigationBarAppearance()
            style.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 20), NSAttributedString.Key.kern: 0.5] as [NSAttributedString.Key : Any]
            navigationController?.navigationBar.scrollEdgeAppearance = style
        }
        let backBtn = UIButton()
        backBtn.frame = CGRectMake(0, 0, 44, 44)
        let imgv = UIImageView()
        backBtn.addSubview(imgv)
        imgv.image = UIImage.init(named: "back")
        imgv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        backBtn.addTarget(self, action: #selector(backBtnDidClick), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
    }
    
    @objc private func backBtnDidClick() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func initSubviews() {
        
        view.backgroundColor = .white
        view.addSubview(statusImgv)
        view.addSubview(titleLabel)
        view.addSubview(timeLabel)
        view.addSubview(amountView)
        view.addSubview(coverView)
        coverView.addSubview(coverImgv)
        coverView.addSubview(nameLabel)
        coverView.addSubview(tokenIdLabel)
        view.addSubview(fromView)
        view.addSubview(toView)
        view.addSubview(txidView)
        view.addSubview(netView)
        //        amountView.addSubview(amountTxt)
        //        amountView.addSubview(amountLabel)
        amountView.addSubview(gasTxt)
        amountView.addSubview(gasLabel)
        //        amountView.addSubview(moneyLabel)
        //        amountView.addSubview(lineV)
        //        amountView.addSubview(totalTxt)
        //        amountView.addSubview(totalLabel)
        fromView.addSubview(fromTxt)
        fromView.addSubview(fromBtn)
        toView.addSubview(toTxt)
        toView.addSubview(toBtn)
        txidView.addSubview(txidTxt)
        txidView.addSubview(txidBtn)
        netView.addSubview(netTxt)
        netView.addSubview(netLabel)
        
        statusImgv.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            } else {
                make.top.equalTo(20)
            }
            make.centerX.equalToSuperview()
            make.height.width.equalTo(58)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(statusImgv.snp.bottom).offset(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        coverView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(30)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(70)
        }
        
        fromView.snp.makeConstraints { make in
            make.top.equalTo(coverView.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(44)
        }
        
        toView.snp.makeConstraints { make in
            make.top.equalTo(fromView.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(44)
        }
        
        txidView.snp.makeConstraints { make in
            make.top.equalTo(toView.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(44)
        }
        
        netView.snp.makeConstraints { make in
            make.top.equalTo(txidView.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(44)
        }
        
        amountView.snp.makeConstraints { make in
            make.top.equalTo(netView.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(44)
        }
        
        coverImgv.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.left.equalTo(18)
            make.width.height.equalTo(48)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.left.equalTo(coverImgv.snp.right).offset(10)
            make.right.equalTo(-20)
            make.height.equalTo(22)
        }
        tokenIdLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(coverImgv.snp.right).offset(10)
            make.height.equalTo(22)
        }
        fromTxt.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(12)
            make.height.equalTo(22)
        }
        
        toTxt.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(12)
            make.height.equalTo(20)
        }
        fromBtn.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.height.equalTo(22)
            make.centerY.equalTo(fromTxt.snp.centerY)
        }
        toBtn.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.height.equalTo(22)
            make.centerY.equalTo(toTxt.snp.centerY)
        }
        txidTxt.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
        txidBtn.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
        
        netTxt.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
        
        netLabel.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
        
        //        amountTxt.snp.makeConstraints { make in
        //            make.left.equalTo(18)
        //            make.top.equalTo(12)
        //            make.height.equalTo(22)
        //        }
        gasTxt.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        //        amountLabel.snp.makeConstraints { make in
        //            make.right.equalTo(-18)
        //            make.height.equalTo(22)
        //            make.top.equalTo(12)
        //        }
        gasLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-12)
            make.height.equalTo(20)
        }
        
        //        moneyLabel.snp.makeConstraints { make in
        //            make.top.equalTo(gasLabel.snp.bottom).offset(0)
        //            make.right.equalTo(-18)
        //            make.height.equalTo(20)
        //        }
        //
        //        lineV.snp.makeConstraints { make in
        //            make.top.equalTo(moneyLabel.snp.bottom).offset(8)
        //            make.left.equalTo(15)
        //            make.right.equalTo(-15)
        //            make.height.equalTo(1)
        //        }
        //
        //        totalTxt.snp.makeConstraints { make in
        //            make.top.equalTo(lineV.snp.bottom).offset(8)
        //            make.left.equalTo(18)
        //            make.height.equalTo(22)
        //        }
        //
        //        totalLabel.snp.makeConstraints { make in
        //            make.top.equalTo(lineV.snp.bottom).offset(8)
        //            make.right.equalTo(-18)
        //            make.height.equalTo(22)
        //        }
        
    }
    
   
    
    private func getAttri(str: String)->NSMutableAttributedString {
        
        let attri = NSMutableAttributedString()
        attri.add(text: str) { attr in
            attr.customFont(14, NotoSans)
            attr.color(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"))
            attr.alignment(.right)
        }.add(text: " ") { att in
            
        }
        attri.addImage("copy", CGRectMake(0, 0, 12, 12))
        
        return attri
    }
    
    @objc private func fromBtnClick() {
        UIPasteboard.general.string = self.detailModel?.fromAddr ?? ""
//        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = .text
//        hud.label.text = "From Address has copy to pasteboard!"
//        hud.label.font = UIFont(name: NotoSans, size: 16)
//        hud.hide(animated: true, afterDelay: 1)
        
        let toast = Go23Toast.init(frame: .zero)
        toast.show("From Address has copy to pasteboard!", after: 1)
    }
    
    @objc private func toBtnClick() {
        UIPasteboard.general.string = self.detailModel?.toAddr ?? ""
//        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = .text
//        hud.label.text = "To Address has copy to pasteboard!"
//        hud.label.font = UIFont(name: NotoSans, size: 16)
//        hud.hide(animated: true, afterDelay: 1)
        let toast = Go23Toast.init(frame: .zero)
        toast.show("To Address has copy to pasteboard!", after: 1)
    }
    
    @objc private func txidBtnClick() {
        UIPasteboard.general.string = self.detailModel?.hash ?? ""
//        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = .text
//        hud.label.text = "TXid has copy to pasteboard!"
//        hud.label.font = UIFont(name: NotoSans, size: 16)
//        hud.hide(animated: true, afterDelay: 1)
        let toast = Go23Toast.init(frame: .zero)
        toast.show("TXid has copy to pasteboard!", after: 1)
    }
    
    
    private lazy var coverView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return view
    }()
    
    private lazy var coverImgv: UIImageView = {
        let imgv = UIImageView()
        imgv.layer.cornerRadius = 4
        return imgv
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.font = UIFont(name: NotoSans, size: 16)
        return label
    }()
    
    private lazy var tokenIdLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.font = UIFont(name: NotoSans, size: 12)
        return label
    }()
    
    private lazy var statusImgv: UIImageView = {
        let imgv = UIImageView()
        return imgv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 32)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: NotoSans, size: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var amountView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return view
    }()
    
    private lazy var fromView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return view
    }()
    
    private lazy var toView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return view
    }()
    
    private lazy var txidView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return view
    }()
    
    private lazy var amountTxt: UILabel = {
        let label = UILabel()
        label.text = "Amount"
        label.font = UIFont(name: NotoSans, size: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var gasTxt: UILabel = {
        let label = UILabel()
        label.text = "Gas Fee"
        label.font = UIFont(name: NotoSans, size: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var totalTxt: UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.font = UIFont(name: BarlowCondensed, size: 16)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var fromTxt: UILabel = {
        let label = UILabel()
        label.text = "From"
        label.font = UIFont(name: NotoSans, size: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var toTxt: UILabel = {
        let label = UILabel()
        label.text = "To"
        label.font = UIFont(name: NotoSans, size: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var txidTxt: UILabel = {
        let label = UILabel()
        label.text = "TxID"
        label.font = UIFont(name: NotoSans, size: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: NotoSans, size: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var gasLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: NotoSans, size: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: NotoSans, size: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 16)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var fromBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: NotoSans, size: 14)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"), for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.addTarget(self, action: #selector(fromBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var toBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: NotoSans, size: 14)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"), for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.addTarget(self, action: #selector(toBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var txidBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: NotoSans, size: 14)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"), for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.addTarget(self, action: #selector(txidBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var lineV: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9")
        return view
    }()
    
    private lazy var netView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return view
    }()
    
    private lazy var netTxt: UILabel = {
        let label = UILabel()
        label.text = "Network"
        label.font = UIFont(name: NotoSans, size: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var netLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: NotoSans, size: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .right
        return label
    }()
    
    
}

extension Go23NFTDetailResultViewController {
    func getTrasactionDetail(isLoading: Bool = true) {
        guard let shared = Go23WalletSDK.shared else {
            return
        }
        if isLoading {
//            self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            Go23Loading.loading()
        }
        shared.getActivityDetail(with: self.hashStr,walletAddress: Go23WalletMangager.shared.address) { [weak self]model in
            if isLoading {
//                self?.hud?.hide(animated: true)
                Go23Loading.clear()
            }
            self?.detailModel = model
            guard let obj = model else {
                return
            }
            //obj.transaction_class = 3 is nft
            self?.timeLabel.isHidden = false
            self?.coverImgv.sd_setImage(with: URL(string: obj.image), placeholderImage:nil)
            self?.nameLabel.text = obj.imageName
            self?.tokenIdLabel.text = "TokenID: "+obj.token
            if obj.status == 2 {
                self?.statusImgv.image = UIImage.init(named: "success")
                self?.titleLabel.text = "Successfully"
            } else if obj.status == 1 {
                self?.statusImgv.image = UIImage.init(named: "waiting")
                self?.titleLabel.text = "Processing..."
                self?.timeLabel.isHidden = true
            } else if obj.status == 3{
                self?.statusImgv.image = UIImage.init(named: "failed")
                self?.titleLabel.text = "Failed"
            }
            
            
            self?.timeLabel.text = obj.time
            self?.gasLabel.text = obj.gasFee+" "+obj.gasSymbol
            let from = String.getSubSecretString(string: obj.fromAddr)
            let to = String.getSubSecretString(string: obj.toAddr)
            let txid = "TokenId "+String.getSubSecretString(string: obj.hash)
            self?.netLabel.text = obj.network
            self?.fromBtn.setAttributedTitle(self?.getAttri(str: from), for: .normal)
            self?.toBtn.setAttributedTitle(self?.getAttri(str: to), for: .normal)
            self?.txidBtn.setAttributedTitle(self?.getAttri(str: txid), for: .normal)
        }
    }
    
}
