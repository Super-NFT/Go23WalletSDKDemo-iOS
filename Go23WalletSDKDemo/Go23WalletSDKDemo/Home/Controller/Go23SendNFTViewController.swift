//
//  Go23SendNFTViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/7.
//

import UIKit
import MBProgressHUD
import Go23SDK

class Go23SendNFTViewController: UIViewController {

    var address = ""
    private var isShowNumView = false
    private var nftNum = 1
    private var tokenId = ""
    private var chainId = 0
    private var transactionModel: Go23TokenTransactionModel?
    private var contract = ""
    
    private var imageData = Data()
    

    var nftDetailModel: Go23NFTDetailModel? {
        didSet {
            guard let model = nftDetailModel else {
                return
            }
            self.tokenId = model.tokenId
            self.chainId = model.chainId
            self.contract = model.contractAddress
            self.nftNum = model.value
            self.isShowNumView = model.tokenStandard == "ERC-1155"
            guard let url = URL(string: Go23WalletMangager.shared.walletModel?.imageUrl ?? "") else {
                return
            }
            DispatchQueue.global().async {
                do {
                    self.imageData = try Data(contentsOf: url)
                }catch let error as NSError {
                    print(error)
                }
            }

            transactionInfo()
            
        }
    }
    private var qrcode = ""
    
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
        
        if self.navgationBar == nil {
            addBarView()
            navgationBar?.title = "Details"
            navgationBar?.attributes = [NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 20), NSAttributedString.Key.kern: 0.5] as [NSAttributedString.Key : Any]
            navgationBar?.leftBarItem = HBarItem.init(customView: backBtn)
        }
    }
    
    @objc private func backBtnDidClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func changeSendBtnStatus(status: Bool) {
        if status {
            self.sendBtn.isUserInteractionEnabled = true
            self.sendBtn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        } else {
            self.sendBtn.isUserInteractionEnabled = false
            self.sendBtn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#E1F4F5")
        }
    }
    
    private func initSubviews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(coverImgv)
        scrollContentView.addSubview(numTxt)
        scrollContentView.addSubview(numLabel)
        scrollContentView.addSubview(numView)
        scrollContentView.addSubview(numMaxLabel)
        scrollContentView.addSubview(allBtn)
        scrollContentView.addSubview(toTxt)
        scrollContentView.addSubview(scanBtn)
        scrollContentView.addSubview(addressTxtView)
        scrollContentView.addSubview(pasteBtn)
        scrollContentView.addSubview(gasTxt)
        scrollContentView.addSubview(gasView)
        gasView.addSubview(gasAmoutLabel)
        gasView.addSubview(gasNumLabel)
        scrollContentView.addSubview(sendBtn)
        scrollContentView.addSubview(cancelBtn)
        scrollContentView.addSubview(lossGassLabel)
        lossGassLabel.isHidden = true
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
        
        coverImgv.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(ScreenWidth-40)
        }
    }
    
    private func layout(isNum: Bool) {
        if isNum {
            numTxt.isHidden = false
            numView.isHidden = false
            numLabel.isHidden = false
            numLabel.text = "Amount Owned: \(self.nftNum)"
            numTxt.snp.makeConstraints { make in
                make.top.equalTo(coverImgv.snp.bottom).offset(30)
                make.leading.equalTo(20)
                make.height.equalTo(22)
            }
            numLabel.snp.makeConstraints { make in
                make.centerY.equalTo(numTxt.snp.centerY)
                make.right.equalTo(-20)
                make.height.equalTo(22)
            }
            numView.snp.makeConstraints { make in
                make.top.equalTo(numTxt.snp.bottom).offset(8)
                make.leading.equalTo(20)
                make.trailing.equalTo(-20)
                make.height.equalTo(48)
            }
            numMaxLabel.snp.makeConstraints { make in
                make.top.equalTo(numView.snp.bottom).offset(4)
                make.leading.equalTo(20)
                make.trailing.equalTo(-20)
                make.height.equalTo(20)
            }
            allBtn.snp.makeConstraints { make in
                make.centerY.equalTo(numTxtFiled.snp.centerY)
                make.trailing.equalTo(-14)
                make.width.equalTo(50)
                make.height.equalTo(44)
            }
            toTxt.snp.makeConstraints { make in
                make.top.equalTo(numMaxLabel.snp.bottom).offset(4)
                make.leading.equalTo(20)
                make.height.equalTo(22)
            }
        } else {
            numTxt.isHidden = true
            numView.isHidden = true
            numLabel.isHidden = true
            numMaxLabel.isHidden = true
            toTxt.snp.makeConstraints { make in
                make.top.equalTo(coverImgv.snp.bottom).offset(30)
                make.leading.equalTo(20)
                make.height.equalTo(22)
            }
        }
        scanBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-10)
            make.centerY.equalTo(toTxt.snp.centerY)
            make.width.height.equalTo(44)
        }
        addressTxtView.snp.makeConstraints { make in
            make.top.equalTo(toTxt.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(64)
        }
        pasteBtn.snp.makeConstraints { make in
            make.centerY.equalTo(addressTxtView.snp.centerY)
            make.trailing.equalTo(-24)
            make.width.equalTo(50)
            make.height.equalTo(44)
        }
        
        gasTxt.snp.makeConstraints { make in
            make.top.equalTo(addressTxtView.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.height.equalTo(22)
        }
        gasView.snp.makeConstraints { make in
            make.top.equalTo(gasTxt.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(44)
        }
        gasAmoutLabel.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.leading.equalTo(12)
            make.height.equalTo(22)
        }
        gasNumLabel.snp.makeConstraints { make in
            make.top.equalTo(gasAmoutLabel.snp.bottom).offset(0)
            make.leading.equalTo(12)
            make.height.equalTo(20)
        }
        
        lossGassLabel.snp.makeConstraints { make in
            make.top.equalTo(gasView.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.height.equalTo(20)
        }
        
        sendBtn.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
             } else {
                 make.bottom.equalTo(0)
            }
            make.width.equalTo(140)
            make.trailing.equalTo(-20)
            make.height.equalTo(46)
        }
        cancelBtn.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
             } else {
                 make.bottom.equalTo(0)
            }
            make.width.equalTo(140)
            make.leading.equalTo(20)
            make.height.equalTo(46)
        }
    }
    
    @objc private func scanBtnClick() {
        let vc = Go23ScanViewController()
        var style = LBXScanViewStyle()
        style.animationImage = UIImage(named: "scanLine")
        style.photoframeLineW = 0
        style.widthRetangleLine = 0
        vc.scanStyle = style
        vc.qrcodeBlock = { [weak self] code  in
            self?.qrcode = code
            self?.addressTxtView.textContainerInset = UIEdgeInsets(top: (64-(self?.getHeight(content: code) ?? 0) )/2.0, left: 10, bottom: 8, right: 50)
            self?.addressTxtView.text = code
            self?.addressHoldLabel.isHidden = true
            if let addressHold = self?.addressHoldLabel, addressHold.isHidden, let obj = self?.transactionModel ,Go23WalletMangager.shared.balance > obj.gas {
                self?.changeSendBtnStatus(status: true)
                self?.lossGassLabel.isHidden = true
            } else {
                self?.changeSendBtnStatus(status: false)
                self?.lossGassLabel.isHidden = false
            }
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func pasteBtnClick() {
        addressTxtView.text = UIPasteboard.general.string
        if addressTxtView.text.count > 0 {
            addressHoldLabel.isHidden = true
        } else {
            return
        }
        addressTxtView.textContainerInset = UIEdgeInsets(top: (64-getHeight(content: UIPasteboard.general.string!))/2.0, left: 10, bottom: 8, right: 50)

        guard let obj = self.transactionModel else {
            return
            
        }
        if addressHoldLabel.isHidden, Go23WalletMangager.shared.balance > obj.gas {
            changeSendBtnStatus(status: true)
            lossGassLabel.isHidden = true
        } else {
            changeSendBtnStatus(status: false)
            lossGassLabel.isHidden = false
        }
    }
    
    private func getHeight(content: String) -> CGFloat {
        let paraph = NSMutableParagraphStyle()
        paraph.alignment = .left
        let attributes = [NSAttributedString.Key.paragraphStyle: paraph, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]

        let rowHeight = (content.trimmingCharacters(in: .newlines) as NSString).boundingRect(with: CGSize(width: ScreenWidth-102.0, height: 0), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: attributes, context: nil).size.height
         return rowHeight
    }
    
    @objc private func sendBtnClick() {
        transactionSign()
    }
    
    @objc private func allBtnClick() {
        self.numTxtFiled.text = "\(self.nftNum)"
    }
    
    @objc private func cancelBtnClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentSize = CGSize(width: 0, height: ScreenHeight)
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    private lazy var scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var coverImgv: UIImageView = {
        let imgv = UIImageView()
        imgv.layer.masksToBounds = true
        imgv.layer.cornerRadius = 8
        return imgv
    }()
    
    private lazy var toTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.text = "To"
        return label
    }()
    
    private lazy var scanBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "grayScan")
        btn.addSubview(imgv)
        imgv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(20)
        }
        btn.addTarget(self, action: #selector(scanBtnClick), for: .touchUpInside)
        return btn
    }()
    private lazy var addressHoldLabel: UILabel = {
        let label = UILabel()
        label.text = "Receiving Address"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#BFBFBF")
        return label
    }()
    private lazy var addressTxtView: UITextView = {
        let txt = UITextView()
        txt.textContainerInset = UIEdgeInsets(top: 22, left: 10, bottom: 8, right: 50)
        txt.font = UIFont.systemFont(ofSize: 14)
        txt.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        txt.tintColor = UIColor.rdt_HexOfColor(hexString: "#BFBFBF")
        txt.layer.cornerRadius = 8
        txt.layer.masksToBounds = true
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        txt.delegate = self
        txt.addSubview(addressHoldLabel)
        addressHoldLabel.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        txt.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        return txt
    }()
    
    private lazy var pasteBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Paste", for: .normal)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#00D6E1"), for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 16)
        btn.addTarget(self, action: #selector(pasteBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var gasTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.text = "Gas Fee"
        return label
    }()
    
    private lazy var gasView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8.0
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return view
    }()
    
    private lazy var gasAmoutLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#595959")
        return label
    }()
    
    private lazy var gasNumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var gasDescLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#BFBFBF")
        return label
    }()
    

    private lazy var sendBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        btn.setTitle("Send", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 24)
        btn.addTarget(self, action: #selector(sendBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#00D6E1"), for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 8
        btn.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1").cgColor
        btn.layer.borderWidth = 1
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 24)
        btn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var lossGassLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#D83548")
        label.text = "Insufficient Gas Fee"
        return label
    }()
    
    private lazy var numTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.text = "Quantity"
        label.isHidden = true
        return label
    }()
    private lazy var numLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.isHidden = true
        label.textAlignment = .right
        return label
    }()
    
    private lazy var allBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("All", for: .normal)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#00D6E1"), for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 16)
        btn.addTarget(self, action: #selector(allBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var numView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F9F9F9")
        view.addSubview(numTxtFiled)
        numTxtFiled.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-10)
        }
        return view
    }()
    private lazy var numTxtFiled: UITextField = {
        let textfield = UITextField()
        textfield.text = "1"
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.leftView = UIView(frame: CGRectMake(0, 0, 8, 0))
        textfield.addTarget(self, action: #selector(textDidChange(_ :)), for: .editingChanged)
        textfield.tintColor = UIColor.rdt_HexOfColor(hexString: "#BFBFBF")
        textfield.keyboardType = UIKeyboardType.decimalPad
        return textfield
    }()
    
    private lazy var numMaxLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#D83548")
        label.text = "Exceed the maximum number of NFT"
        return label
    }()

}

extension Go23SendNFTViewController : UITextViewDelegate {
    //textfield
    @objc func textDidChange(_ textField:UITextField) {
        if let txt = textField.text, let num = Int(txt) {
            if num > self.nftNum {
                numMaxLabel.isHidden = false
            } else {
                numMaxLabel.isHidden = true
            }
        } else {
            numMaxLabel.isHidden = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        addressTxtView.textContainerInset = UIEdgeInsets(top: 22, left: 10, bottom: 8, right: 50)
        addressHoldLabel.isHidden = !textView.text.isEmpty
        guard let obj = self.transactionModel else {
            return
            
        }
        if addressHoldLabel.isHidden, Go23WalletMangager.shared.balance > obj.gas {
            changeSendBtnStatus(status: true)
            lossGassLabel.isHidden = true
        } else {
            changeSendBtnStatus(status: false)
            lossGassLabel.isHidden = false
        }
    }
}

extension Go23SendNFTViewController {
    
    func transactionInfo() {
        guard let shared = Go23WalletSDK.shared else {
            return
        }
        Go23Loading.loading()
        shared.getNFTTransactionInfo(for: self.chainId, from: Go23WalletMangager.shared.address) { [weak self] model in
            Go23Loading.clear()
            self?.transactionModel = model
            guard let obj = model else {
                return
            }
            self?.coverImgv.sd_setImage(with: URL(string: self?.nftDetailModel?.image ?? ""), placeholderImage: nil)
            self?.layout(isNum: self?.isShowNumView ?? false)
            
            if obj.gas.count > 0, let walletObj = Go23WalletMangager.shared.walletModel, let holdLabel = self?.addressHoldLabel {
                self?.gasTxt.isHidden = false
                self?.gasAmoutLabel.isHidden = false
                self?.gasAmoutLabel.text = obj.gas + " " + walletObj.symbol
                
                if Go23WalletMangager.shared.balance > obj.gas, holdLabel.isHidden {
                    self?.changeSendBtnStatus(status: true)
                } else {
                    self?.changeSendBtnStatus(status: false)
                }
                
            } else {
                self?.gasTxt.isHidden = true
                self?.gasAmoutLabel.isHidden = true
            }
        }
    }
    
    
    
    func transactionSign() {
        guard let shared = Go23WalletSDK.shared else {
            return
        }
        
        guard let obj = self.transactionModel else {
            return
        }
        
        let sign = Go23SendTransactionModel(type: 1,
                                            rpc: Go23WalletMangager.shared.walletModel?.rpc ?? "",
                                            chainId: Go23WalletMangager.shared.walletModel?.chainId ?? 0,
                                            fromAddr: Go23WalletMangager.shared.address,
                                            toAddr: addressTxtView.text,
                                            transType: 3,
                                            contractAddress: self.contract,
                                            tokenId: self.tokenId,
                                            value: numTxtFiled.text ?? "1",
                                            middleContractAddress: Go23WalletMangager.shared.walletModel?.middleContractAddress ?? "",
                                            decimal: obj.decimal,
                                            nftName: self.nftDetailModel?.name ?? "",
                                            tokenIcon: self.imageData,
                                            chainName: Go23WalletMangager.shared.walletModel?.name ?? "")
        
//        let sign = Go23SendTransactionModel.init(
//            type: 1,
//            chainId: 43113,
//            chainUrl: "https://few-restless-diamond.avalanche-testnet.discover.quiknode.pro/4d6fb93e233e9744fe1138b3c0761527ee882be3/ext/bc/C/rpc",
//            blockId: 1,
//            fromAddr: Go23WalletMangager.shared.address,
//            toAddr: "0x5eef0e147321f7d6b3e8a380f7fa139ff23ccec9",
//            transType: 3,
//            contract: "0xbe98f9807b3f480632fe05d9dc5dac85b43232cd",
//            token: "1666324619169126",
//            value: "1",
//            middleContract: "0x2185C155d00ca80F9bB09bb21B682D5fa6fF81c9")
    
        Go23Loading.loading()
        shared.sendTransaction(with: sign) { (status, hash) in

            Go23Loading.clear()
            if !status {
                let toast = Go23Toast.init(frame: .zero)
                toast.show("Transaction failed!", after: 1)
                return
            }
                let alert = Go23NFTStatusView(frame: CGRectMake(0, 0, ScreenWidth, 360))
                if status {
                    alert.filled(status: true)
                } else {
                    alert.filled(status: false)
                }
                let ovc = OverlayController(view: alert)
                alert.hashStr = hash
                ovc.maskStyle = .black(opacity: 0.4)
                ovc.layoutPosition = .bottom
                ovc.presentationStyle = .fromToBottom
                ovc.isDismissOnMaskTouched = false
                ovc.isPanGestureEnabled = true
                UIApplication.shared.keyWindow?.present(overlay: ovc)
            
        }
    }


}
