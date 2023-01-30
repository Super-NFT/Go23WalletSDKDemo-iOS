//
//  Go23TokenDetailResultViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/6.
//

import UIKit
import MBProgressHUD
import Go23SDK

class Go23TokenDetailResultViewController: UIViewController {
    
    
    private var timer: Timer?

    var hashStr = ""
    var detailModel: Go23ActivityDetailModel?
    
    var isPopRoot = true
    
    var hud: MBProgressHUD?
    
    deinit {
        removeTimer()
    }
    
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
        if isPopRoot {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
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
    
    
    private func initSubviews() {
        
        view.backgroundColor = .white
        view.addSubview(statusImgv)
        view.addSubview(titleLabel)
        view.addSubview(timeLabel)
        view.addSubview(amountView)
        view.addSubview(fromView)
        view.addSubview(toView)
        view.addSubview(txidView)
        view.addSubview(netView)
        view.addSubview(lendingGasView)
        amountView.addSubview(amountTxt)
        amountView.addSubview(amountLabel)
        amountView.addSubview(gasTxt)
        amountView.addSubview(gasLabel)
        fromView.addSubview(fromTxt)
        fromView.addSubview(fromBtn)
        toView.addSubview(toTxt)
        toView.addSubview(toBtn)
        txidView.addSubview(txidTxt)
        txidView.addSubview(txidBtn)
        netView.addSubview(netTxt)
        netView.addSubview(netLabel)
        lendingGasView.addSubview(lendingGasTxt)
        lendingGasView.addSubview(lendingGasLabel)
        
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
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        fromView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(30)
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
            make.height.equalTo(70)
        }
        
        lendingGasView.snp.makeConstraints { make in
            make.top.equalTo(amountView.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(44)
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
        
        amountTxt.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(12)
            make.height.equalTo(22)
        }
        gasTxt.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.equalTo(amountTxt.snp.bottom).offset(0)
            make.height.equalTo(20)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.height.equalTo(22)
            make.top.equalTo(12)
        }
        gasLabel.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(0)
            make.right.equalTo(-12)
            make.height.equalTo(20)
        }
        
        lendingGasTxt.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
        
        lendingGasLabel.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
        

        
    }
    
    
    private func getAttri(str: String)->NSMutableAttributedString {
        
        let attri = NSMutableAttributedString()
        attri.add(text: str) { attr in
            attr.font(14)
            attr.color(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"))
            attr.alignment(.right)
        }.add(text: " ") { att in
            
        }
        attri.addImage("copy", CGRectMake(0, 0, 12, 12))
        
        return attri
    }
    
    @objc private func fromBtnClick() {
        UIPasteboard.general.string = self.detailModel?.fromAddr ?? ""
        
        let totast = Go23Toast.init(frame: .zero)
        totast.show("Copied!", after: 1)
    }
    
    @objc private func toBtnClick() {
        UIPasteboard.general.string = self.detailModel?.toAddr ?? ""
        
        let totast = Go23Toast.init(frame: .zero)
        totast.show("Copied!", after: 1)
    }
    
    @objc private func txidBtnClick() {
        UIPasteboard.general.string = self.detailModel?.hash ?? ""
        
        let totast = Go23Toast.init(frame: .zero)
        totast.show("Copied!", after: 1)
    }
    
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
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var amountView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return view
    }()
    
    private lazy var fromView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return view
    }()
    
    private lazy var toView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return view
    }()
    
    
    private lazy var txidView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return view
    }()
    
    private lazy var lendingGasView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return view
    }()
    
    private lazy var amountTxt: UILabel = {
        let label = UILabel()
        label.text = "Amount"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var gasTxt: UILabel = {
        let label = UILabel()
        label.text = "Gas Fee"
        label.font = UIFont.systemFont(ofSize: 12)
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
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var toTxt: UILabel = {
        let label = UILabel()
        label.text = "To"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var txidTxt: UILabel = {
        let label = UILabel()
        label.text = "TxID"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var gasLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
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
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"), for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.addTarget(self, action: #selector(fromBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var toBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"), for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.addTarget(self, action: #selector(toBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var txidBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
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
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return view
    }()
    
    private lazy var netTxt: UILabel = {
        let label = UILabel()
        label.text = "Network"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var netLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var lendingGasTxt: UILabel = {
        let label = UILabel()
        label.text = "Equivalent Gas Fee"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var lendingGasLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .right
        return label
    }()
    
    
}

extension Go23TokenDetailResultViewController {
    func getTrasactionDetail(isLoading: Bool = true) {
        guard let shared = Go23WalletSDK.shared else {
            return
        }
        
        if isLoading {
            Go23Loading.loading()
        }
                
        
        shared.getActivityDetail(with: self.hashStr, walletAddress: Go23WalletMangager.shared.address) { [weak self]model in
            self?.detailModel = model
            if isLoading {
                Go23Loading.clear()
            }
            guard let obj = model else {
                return
            }
            self?.timeLabel.isHidden = false
            if obj.status == 2 {
                self?.statusImgv.image = UIImage.init(named: "success")
                self?.titleLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 32), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: "Successful")
            } else if obj.status == 1 {
                self?.statusImgv.image = UIImage.init(named: "waiting")
                self?.titleLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 32), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: "Processing...")

                self?.timeLabel.isHidden = true
            } else if obj.status == 3{
                self?.statusImgv.image = UIImage.init(named: "failed")
                self?.titleLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 32), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: "Failed")


            }
            
            if Double(obj.lendingGasFee)! > 0 {
                self?.lendingGasView.isHidden = false
                self?.lendingGasLabel.text = obj.lendingGasFee+" "+obj.symbol
            } else {
                self?.lendingGasView.isHidden = true
            }
            self?.timeLabel.text = obj.time
            self?.amountLabel.text = obj.amount+" "+obj.symbol
            self?.gasLabel.text = obj.gasFee+" "+obj.gasSymbol
            let from = String.getSubSecretString(string: obj.fromAddr)
            let to = String.getSubSecretString(string: obj.toAddr)
            let txid = String.getSubSecretString(string: obj.hash)
            self?.netLabel.text = obj.network
            self?.fromBtn.setAttributedTitle(self?.getAttri(str: from), for: .normal)
            self?.toBtn.setAttributedTitle(self?.getAttri(str: to), for: .normal)
            self?.txidBtn.setAttributedTitle(self?.getAttri(str: txid), for: .normal)
        }
    }
}
