//
//  Go23SendViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/7.
//

import UIKit
import Kingfisher
import Go23SDK

class Go23SendViewController: UIViewController {
    
    var isSupportSel = false
    
    var address = ""
    
    private var chainId = 0
    private var transactionModel: Go23TokenTransactionModel?
    private var symbol = ""
    private var contract = ""
    private var chainName = ""
    
    private var imageData = Data()
    
    private var isAmountAll = false
    private var isShowBalance = false
    
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
            navgationBar?.title = "Send"
            navgationBar?.attributes = [NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 20), NSAttributedString.Key.kern: 0.5] as [NSAttributedString.Key : Any]
            navgationBar?.leftBarItem = HBarItem.init(customView: backBtn)
        }
    }
    
    @objc private func backBtnDidClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func initSubviews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(headerView)
        scrollContentView.addSubview(fromTxt)
        scrollContentView.addSubview(fromView)
        fromView.addSubview(typeLabel)
        fromView.addSubview(fromBtn)
        scrollContentView.addSubview(toTxt)
        scrollContentView.addSubview(scanBtn)
        scrollContentView.addSubview(addressTxtView)
        scrollContentView.addSubview(pasteBtn)
        scrollContentView.addSubview(amoutTxt)
        scrollContentView.addSubview(amoutLabel)
        scrollContentView.addSubview(amoutView)
        amoutView.addSubview(amoutTxtFiled)
        amoutView.addSubview(numLabel)
        amoutView.addSubview(allBtn)
        amoutView.addSubview(lineV)
        amoutView.addSubview(clearBtn)
        amoutView.addSubview(amoutTypeLabel)
        scrollContentView.addSubview(gasTxt)
        scrollContentView.addSubview(gasView)
        gasView.addSubview(gasAmoutLabel)
        gasView.addSubview(gasNumLabel)
        scrollContentView.addSubview(supportGasBtn)
        scrollContentView.addSubview(minTokenLabel)
        scrollContentView.addSubview(sendBtn)
        scrollContentView.addSubview(noGasfeeLabel)
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
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }
        
        fromTxt.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(12)
            make.leading.equalTo(20)
            make.height.equalTo(22)
        }
        
        fromView.snp.makeConstraints { make in
            make.top.equalTo(fromTxt.snp.bottom).offset(8)
            make.height.equalTo(46)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.leading.equalTo(12)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        fromBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-12)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        toTxt.snp.makeConstraints { make in
            make.top.equalTo(fromView.snp.bottom).offset(16)
            make.leading.equalTo(20)
            make.height.equalTo(22)
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
        amoutTxt.snp.makeConstraints { make in
            make.top.equalTo(addressTxtView.snp.bottom).offset(32)
            make.leading.equalTo(20)
            make.height.equalTo(22)
        }
        amoutLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.height.equalTo(16)
            make.centerY.equalTo(amoutTxt.snp.centerY)
        }
        amoutView.snp.makeConstraints { make in
            make.top.equalTo(amoutTxt.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(72)
        }
        amoutTxtFiled.snp.makeConstraints { make in
            make.leading.equalTo(8)
            make.top.equalTo(12)
            make.width.equalTo(150)
            make.height.equalTo(28)
        }
        numLabel.snp.makeConstraints { make in
            make.leading.equalTo(8)
            make.top.equalTo(amoutTxtFiled.snp.bottom)
            make.height.equalTo(20)
        }
        allBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-8)
            make.width.equalTo(30)
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        lineV.snp.makeConstraints { make in
            make.trailing.equalTo(allBtn.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(12)
        }
        amoutTypeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(lineV.snp.leading).offset(-12)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        clearBtn.snp.makeConstraints { make in
            make.trailing.equalTo(amoutTypeLabel.snp.leading).offset(-4)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        gasTxt.snp.makeConstraints { make in
            make.top.equalTo(amoutView.snp.bottom).offset(16)
            make.leading.equalTo(20)
            make.height.equalTo(22)
        }
        gasView.snp.makeConstraints { make in
            make.top.equalTo(gasTxt.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(66)
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
        
        supportGasBtn.snp.makeConstraints { make in
            make.top.equalTo(gasView.snp.bottom).offset(12)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(25)
        }
        noGasfeeLabel.snp.makeConstraints { make in
            make.top.equalTo(gasView.snp.bottom).offset(12)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(36)
        }
        sendBtn.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
             } else {
                 make.bottom.equalTo(0)
            }
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(46)
        }
        
        changeSendBtnStatus(status: false)
        clearBtn.isHidden = true

    }
    
    @objc private func fromBtnClick() {
        UIPasteboard.general.string = Go23WalletMangager.shared.address
        let toast = Go23Toast.init(frame: .zero)
        toast.show("Copied!", after: 1)
        
    }
    
    
    @objc private func scanBtnClick() {
        addressTxtView.resignFirstResponder()
        amoutTxtFiled.resignFirstResponder()
        let vc = Go23ScanViewController()
        var style = LBXScanViewStyle()
        style.animationImage = UIImage(named: "scanLine")
        style.photoframeLineW = 0
        style.widthRetangleLine = 0
        style.xScanRetangleOffset = 0
        vc.scanStyle = style
        vc.qrcodeBlock = { [weak self] code  in
            self?.address = code
            self?.addressTxtView.textContainerInset = UIEdgeInsets(top: (64-(self?.getHeight(content: code) ?? 0) )/2.0, left: 10, bottom: 8, right: 50)
            self?.addressTxtView.text = code
            self?.addressHoldLabel.isHidden = true
            if let addressHold = self?.addressHoldLabel, let transInfo = self?.transactionModel, addressHold.isHidden, let amountT = self?.amoutTxtFiled.text, amountT.count > 0, transInfo.transType != 0,let dTxt = Double(amountT), let fee = Double(transInfo.tokenMinimum) {
                if dTxt <= fee {
                    self?.changeSendBtnStatus(status: false)
                    return
                }
                self?.changeSendBtnStatus(status: true)
            }
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc private func pasteBtnClick() {
        
        if let paste = UIPasteboard.general.string, paste.count <= 0 {
            return
        }

        addressTxtView.text = UIPasteboard.general.string
        if addressTxtView.text.count > 0 {
            addressHoldLabel.isHidden = true
        } else{
            return
        }
        
        addressTxtView.textContainerInset = UIEdgeInsets(top: (64-getHeight(content: UIPasteboard.general.string!))/2.0, left: 10, bottom: 8, right: 50)
        if let obj = self.transactionModel, let gas = Double(obj.gas), let txt = amoutTxtFiled.text, let dTxt = Double(txt), let fee = Double(obj.tokenMinimum) {
            if dTxt <= fee {
                changeSendBtnStatus(status: false)
                return
            }
            changeStatus(dTxt: dTxt, gas: gas)
        }
    }
    
    private func getHeight(content: String) -> CGFloat {
        let paraph = NSMutableParagraphStyle()
        paraph.alignment = .left
        let attributes = [NSAttributedString.Key.paragraphStyle: paraph, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]

        let rowHeight = (content.trimmingCharacters(in: .newlines) as NSString).boundingRect(with: CGSize(width: ScreenWidth-102.0, height: 0), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: attributes, context: nil).size.height
         return rowHeight
    }
    
    @objc private func clearBtnClick() {
        amoutTxtFiled.text = ""
        
        totalLabel.text = "0.0 "+symbol
        if !numLabel.isHidden {
            numLabel.text = "$0.0"
        }
        changeSendBtnStatus(status: false)

    }
    
    @objc private func allBtnClick() {
        guard let obj = self.transactionModel,let gas = Double(obj.gas), let platB = Double(obj.platformBalanceSort), let platU = Double(obj.platformUPer), let tokenS = Double(obj.tokenBalanceSort), let tokenU = Double(obj.tokenUPer),let fee = Double(obj.tokenMinimum)  else {
            return
        }
        
        
        
        var amout = 0.0
        var money = 0.0
        var isGray = false

        if self.contract.count == 0 {
            amout = platB-gas
            let decimalPlat = NSDecimalNumber(string: obj.platformBalanceSort)

            let decimalGas = NSDecimalNumber(string: obj.gas)
            let decimalFee = NSDecimalNumber(string: obj.tokenMinimum)
            
            if decimalPlat.subtracting(decimalGas).compare(decimalFee) != ComparisonResult.orderedDescending {
                let toast = Go23Toast.init(frame: .zero)
                toast.show("Insufficient balance", after: 1)
                return
            }
            
            if amout <= 0 {
                changeSendBtnStatus(status: false)
                let toast = Go23Toast.init(frame: .zero)
                toast.show("Insufficient Gas Fee", after: 1)
                return
            }
            clearBtn.isHidden = false
            money = amout * platU
            totalLabel.text = "\(platB) "+symbol
            
            if amout == 0 || amout > platB || obj.transType == 0 {
                isGray = false
            } else {
                isGray = true
            }
        } else {
            amout = tokenS
            if amout <= fee {
                let toast = Go23Toast.init(frame: .zero)
                toast.show("Insufficient balance", after: 1)
                return
            }
            money = amout * tokenU
            if amout == 0 || amout > tokenS || obj.transType == 0 {
                isGray = false
            } else {
                isGray = true
            }
            clearBtn.isHidden = false
            totalLabel.text = "\(tokenS) "+symbol

        }
        amoutTxtFiled.text = "\(amout)"
        self.isAmountAll = true
        if !numLabel.isHidden {
            numLabel.text = "$\(money)"
            amoutTxtFiled.snp.remakeConstraints { make in
                make.leading.equalTo(8)
                    make.top.equalTo(12)
                make.width.equalTo(150)
                make.height.equalTo(28)
            }
        }
        
        if addressTxtView.text.count <= 0 {
            isGray = false
        }
        
        changeSendBtnStatus(status: isGray)

    }
    
    @objc private func sendBtnClick() {
        transactionSign()
    }
    
    @objc private func supportGasBtnClick() {
        
        if isSupportSel {
            isSupportSel = false
            supportClick(selected:  false)
            changeSendBtnStatus(status: false)
            
        } else {
            isSupportSel = true
            supportClick(selected: true)
            if let obj = self.transactionModel, let gas = Double(obj.gas), let txt = amoutTxtFiled.text, let dTxt = Double(txt) {
                changeStatus(dTxt: dTxt, gas: gas)
            }        }
        
        
       
    }
    
    private func supportClick(selected: Bool) {
        let attri = NSMutableAttributedString()
        if selected {
            attri.addImage("blueSel", CGRectMake(0, -2, 16, 16))
        } else {
            attri.addImage("graySel", CGRectMake(0, -2, 16, 16))
        }
        attri.add(text: " ") { att in
            
        }
        attri.add(text: "\(self.chainName)") { attr in
            attr.font(14)
            attr.color(UIColor.rdt_HexOfColor(hexString: "#00D6E1"))
            attr.alignment(.center)
        }
        attri.add(text: " support lending gas to users for trading") { attr in
            attr.font(14)
            attr.color(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"))
            attr.alignment(.center)
        }
        
        supportGasBtn.setAttributedTitle(attri, for: .normal)
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
    
    private lazy var headerView: SendHeaderView = {
        let header = SendHeaderView()
        header.clickBlock = { [weak self] in
            let alert = Go23SendTokenListView(frame: CGRectMake(0, 0, ScreenWidth, 720))
            let ovc = OverlayController(view: alert)
            ovc.maskStyle = .black(opacity: 0.4)
            ovc.layoutPosition = .bottom
            ovc.presentationStyle = .fromToBottom
            ovc.isDismissOnMaskTouched = false
            ovc.isPanGestureEnabled = false
            alert.addBtnBlock = { [weak self] in
                let vc = Go23AddTokenViewController()
                self?.navigationController?.pushViewController(vc, animated: true)

            }
            alert.clickBlock = {[weak self]model in
                self?.view.dissmiss(overlay: .last)
                self?.headerView.filled(cover: model.imageUrl, name: model.name)
                self?.chainName = model.name
                self?.chainId = model.chainId
                self?.symbol = model.symbol
                self?.contract = model.contractAddr
                self?.transactionInfo()
                guard let url = URL(string: model.imageUrl) else {
                    return
                }
                DispatchQueue.global().async {
                    do {
                        self?.imageData = try Data(contentsOf: url)
                    }catch let error as NSError {
                        print(error)
                    }
                }
                
            }
            
            alert.closeBlock = {[weak self] in
                self?.view.dissmiss(overlay: .last)
            }

            self?.view.present(overlay: ovc)
        }
        return header
    }()
    
    private lazy var fromTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.text = "From"
        return label
    }()
    
    private lazy var fromView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12.0
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#E0E0E0").cgColor
        return view
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
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
        txt.textContainerInset = UIEdgeInsets(top: 22, left: 12, bottom: 8, right: 50)
        txt.font = UIFont.systemFont(ofSize: 14)
        txt.tintColor = UIColor.rdt_HexOfColor(hexString: "#BFBFBF")
        txt.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        txt.layer.cornerRadius = 12.0
        txt.layer.masksToBounds = true
        txt.layer.borderWidth = 1
        txt.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#E0E0E0").cgColor
        txt.delegate = self
        txt.addSubview(addressHoldLabel)
        addressHoldLabel.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        txt.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#FAFAFA")
        return txt
    }()
    private lazy var pasteBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Paste", for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#00D6E1"), for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 16)
        btn.addTarget(self, action: #selector(pasteBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var amoutTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.text = "Amount"
        return label
    }()
    
    private lazy var amoutLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var amoutView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#FAFAFA")
        view.layer.cornerRadius = 12.0
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#E0E0E0").cgColor
        return view
    }()
    private lazy var amoutTxtFiled: UITextField = {
        let textfield = UITextField()
        textfield.text = ""
        textfield.font = UIFont(name: BarlowCondensed, size: 20)
        let attributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16) as Any,  NSAttributedString.Key.foregroundColor:UIColor.rdt_HexOfColor(hexString: "#BFBFBF")] as [NSAttributedString.Key : Any]
        let attri = NSAttributedString(string: "Enter Amount", attributes: attributes as [NSAttributedString.Key : Any])
        textfield.leftViewMode = .always
        textfield.leftView = UIView(frame: CGRectMake(0, 0, 8, 0))
        textfield.attributedPlaceholder = attri
        textfield.addTarget(self, action: #selector(textDidChange(_ :)), for: .editingChanged)
        textfield.addTarget(self, action: #selector(textDidEnd(_ :)), for: .editingDidEnd)
        textfield.tintColor = UIColor.rdt_HexOfColor(hexString: "#BFBFBF")
        textfield.keyboardType = UIKeyboardType.decimalPad
        return textfield
    }()
    
    private lazy var numLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#BFBFBF")
        return label
    }()
    
    private lazy var clearBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "clear")
        btn.addSubview(imgv)
        imgv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(16)
        }
        btn.addTarget(self, action: #selector(clearBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var amoutTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 16)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#BFBFBF")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var lineV: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9")
        return view
    }()
    
    private lazy var allBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("All", for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#00D6E1"), for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 16)
        btn.addTarget(self, action: #selector(allBtnClick), for: .touchUpInside)
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
        view.layer.cornerRadius = 12.0
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#E0E0E0").cgColor
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
    
    private lazy var totalTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 20)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.text = "Total"
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 20)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.textAlignment = .right
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
    
    private lazy var supportGasBtn: UIButton = {
        let label = UIButton()
        label.titleLabel?.textAlignment = .center
        label.addTarget(self, action: #selector(supportGasBtnClick), for: .touchUpInside)
        return label
    }()
    private lazy var minTokenLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.isHidden = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var noGasfeeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.isHidden = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
}


class SendHeaderView: UIView {
    
    var clickBlock: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        isUserInteractionEnabled = true
        backgroundColor = UIColor.rdt_HexOfColor(hexString: "#E1F4F5")
        addSubview(coverImgv)
        addSubview(titleLabel)
        addSubview(descLabel)
        addSubview(arrowImgv)
        addSubview(control)
        
        coverImgv.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(coverImgv.snp.right).offset(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
        
        descLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-35)
            make.centerY.equalToSuperview().offset(2)
            make.height.equalTo(24)
        }
        
        arrowImgv.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.centerY.equalToSuperview().offset(2)
            make.width.equalTo(11)
            make.height.equalTo(11)
        }
        
        control.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    func filled(cover: String, name: String) {
        self.coverImgv.kf.setImage(with: URL(string: cover))
        self.titleLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 18), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .left, title: name)
    }
    
    @objc private func controlClick() {
        self.clickBlock?()
    }
    
    private lazy var coverImgv: UIImageView = {
        let imgv = UIImageView()
        
        return imgv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 18)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Change Asset"
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var arrowImgv: UIImageView = {
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "blueNext")
        return imgv
    }()
    
    private lazy var control: UIControl = {
        let control = UIControl()
        control.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
        return control
    }()
}

extension Go23SendViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        addressHoldLabel.isHidden = !textView.text.isEmpty
        addressTxtView.textContainerInset = UIEdgeInsets(top: 22, left: 10, bottom: 8, right: 50)
        if addressHoldLabel.isHidden, let amountT = amoutTxtFiled.text, amountT.count > 0, let info = self.transactionModel,info.transType != 0 {
            changeSendBtnStatus(status: true)
        }
        
    }
}

extension Go23SendViewController {
    func transactionInfo() {
        guard let shared = Go23WalletSDK.shared else {
            return
        }
                
        Go23Loading.loading()
        shared.getTokenTransactionInfo(for: self.contract, chainId: self.chainId, from: Go23WalletMangager.shared.address) { [weak self]model in
            Go23Loading.clear()
            guard let obj = model, let symbol = self?.symbol else {
                return
            }
            self?.transactionModel = obj
            if !obj.isLendingGas {
                self?.supportGasBtn.isHidden = true
                self?.supportGasBtn.isUserInteractionEnabled = false
                self?.noGasfeeLabel.isHidden = false
                let attri = NSMutableAttributedString()
                attri.add(text: symbol) { attribute in
                    attribute.font(14)
                    attribute.color(UIColor.rdt_HexOfColor(hexString: "#00D6E1"))
                    attribute.alignment(.center)
                }.add(text: " doesn’t support lending gas to users for transaction.") { attribute in
                    attribute.font(14)
                    attribute.color(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"))
                    attribute.alignment(.center)
                }
                self?.noGasfeeLabel.attributedText = attri
                self?.minTokenLabel.isHidden = true
            } else {
                self?.noGasfeeLabel.isHidden = true
                self?.supportGasBtn.isHidden = false
                self?.supportGasBtn.isUserInteractionEnabled = true
                self?.isSupportSel = obj.isLendingGas
                self?.supportClick(selected: self?.isSupportSel ?? false)
                let paraph = NSMutableParagraphStyle()
                paraph.alignment = .left
                paraph.lineSpacing = 3
                let attributes = [NSAttributedString.Key.paragraphStyle: paraph, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]

                let rowHeight = ("Minimum transfer amount: \(obj.tokenMinimum) \(symbol)".trimmingCharacters(in: .newlines) as NSString).boundingRect(with: CGSize(width: ScreenWidth-40.0, height: 0), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: attributes, context: nil).size.height
                if let label = self?.minTokenLabel, let supportBtn = self?.supportGasBtn {
                    label.snp.makeConstraints { make in
                        make.top.equalTo(supportBtn.snp.bottom).offset(3)
                        make.leading.equalTo(20)
                        make.trailing.equalTo(-20)
                        make.height.equalTo(rowHeight)
                    }
                    self?.minTokenLabel.isHidden = false
                    let attri = NSMutableAttributedString()
                    attri.add(text: "Minimum transfer amount: ") { attribute in
                        attribute.font(14)
                        attribute.color(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"))
                        attribute.alignment(.center)
                    }.add(text: obj.tokenMinimum) { attribute in
                        attribute.font(14)
                        attribute.color(UIColor.rdt_HexOfColor(hexString: "#00D6E1"))
                        attribute.alignment(.center)
                    }.add(text: " \(symbol)") { attribute in
                        attribute.font(14)
                        attribute.color(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"))
                        attribute.alignment(.center)
                    }
                    self?.minTokenLabel.attributedText = attri
                }
            }

            self?.totalLabel.text = "0.0 "+symbol
            self?.gasAmoutLabel.text = obj.gas + " " + (Go23WalletMangager.shared.walletModel?.symbol ?? "")
            self?.changeSendBtnStatus(status: false)
            self?.typeLabel.text = symbol
            self?.amoutTxtFiled.snp.remakeConstraints { make in
                make.leading.equalTo(8)
                make.centerY.equalToSuperview()
                make.width.equalTo(150)
                make.height.equalTo(28)
            }
            //Judging whether it is a platform currency or a token by whether the contract address is empty
            if self?.contract.count ?? 0 == 0 {
                self?.amoutLabel.text = "Available: \(obj.platformBalanceSort) \(symbol)"
                guard let platformU = Double(obj.platformUPer) else {return}
                if platformU <= 0 {
                    self?.numLabel.isHidden = true
                    self?.gasNumLabel.isHidden = true

                } else {
                    self?.numLabel.isHidden = false
                    self?.gasNumLabel.isHidden = false
                    if let amoutTxt = self?.amoutTxtFiled.text, let amoutD = Double(amoutTxt), let gas = Double(obj.gas) {
                        self?.numLabel.text = "$\(platformU*amoutD)"

                    }
                    if let gas = Double(obj.gas)  {
                        self?.gasNumLabel.text = "$\(gas*platformU)"
                    }
                    
                }

            } else {
                self?.amoutLabel.text = "Available: \(obj.tokenBalanceSort) \(symbol)"
                guard let tokenU = Double(obj.tokenUPer) else {return}
                if tokenU <= 0 {
                    self?.numLabel.isHidden = true
                    self?.gasNumLabel.isHidden = true
                } else {
                    self?.numLabel.isHidden = false
                    self?.gasNumLabel.isHidden = false
                    if let amoutTxt = self?.amoutTxtFiled.text, let amoutD = Double(amoutTxt), let gas = Double(obj.gas) {
                        self?.numLabel.text = "$\(tokenU*amoutD)"
                    }
                    if let gas = Double(obj.gas) {
                        guard let platformU = Double(obj.platformUPer) else {return}
                        self?.gasNumLabel.text = "$\(gas*platformU)"
                    }
                    
                }

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
        
        
        var amoutStr = ""
        if isAmountAll {
            if self.contract.count > 0 {
                amoutStr = obj.tokenBalanceSort
            } else {
                let decimalPlatform = NSDecimalNumber(string: obj.platformBalanceSort)
                let decimalGas = NSDecimalNumber(string: obj.gas)
                
                let aa = decimalPlatform.subtracting(decimalGas)
                amoutStr = "\(aa)"
            }
        } else {
            amoutStr = amoutTxtFiled.text ?? ""
        }
        
        let sign = Go23SendTransactionModel(type: 1,
                                            rpc: Go23WalletMangager.shared.walletModel?.rpc ?? "",
                                            chainId: Go23WalletMangager.shared.walletModel?.chainId ?? 0,
                                            fromAddr: Go23WalletMangager.shared.address,
                                            toAddr: addressTxtView.text,
                                            transType: obj.transType,
                                            contractAddress: self.contract,
                                            tokenId: "", value: amoutStr,
                                            middleContractAddress: Go23WalletMangager.shared.walletModel?.middleContractAddress ?? "",
                                            decimal: obj.decimal,
                                            nftName: "",
                                            tokenIcon: self.imageData,
                                            chainName: self.chainName)
        
//        let sign = Go23SendTransactionModel(
//            type: 1,
//            chainId: 43113,
//            chainUrl: "https://few-restless-diamond.avalanche-testnet.discover.quiknode.pro/4d6fb93e233e9744fe1138b3c0761527ee882be3/ext/bc/C/rpc",
//            blockId: 1,
//            fromAddr: Go23WalletMangager.shared.address,
//            toAddr: "0x5eef0e147321f7d6b3e8a380f7fa139ff23ccec9",
//            transType: 2,
//            contract: "0xEe1c38135561e3cEfaf30D84D22804f459A98D26",
//            token: "",
//            value: "10",
//            middleContract: "0x2185C155d00ca80F9bB09bb21B682D5fa6fF81c9")
    
        Go23Loading.loading()
        shared.sendTransaction(with: sign) { (status, hash) in
            Go23Loading.clear()
            if !status {

                let toast = Go23Toast.init(frame: .zero)
                toast.show("Transaction failed!", after: 1)
                return
            }
                let alert = Go23TransactionResultView(frame: CGRectMake(0, 0, ScreenWidth, 360))
                if status {
                    alert.filled(status: true, msg: "", tips: "")
                } else {
                    alert.filled(status: false, msg: "", tips: "")
                }
                alert.hashStr = hash
                let ovc = OverlayController(view: alert)
                ovc.maskStyle = .black(opacity: 0.4)
                ovc.layoutPosition = .bottom
                ovc.presentationStyle = .fromToBottom
                ovc.isDismissOnMaskTouched = false
                ovc.isPanGestureEnabled = false
                UIApplication.shared.keyWindow?.present(overlay: ovc)
            
        }
    }
    
    
    private func changeStatus(dTxt: Double, gas: Double) {
        guard let obj = self.transactionModel,let gas = Double(obj.gas), let platB = Double(obj.platformBalanceSort), let platU = Double(obj.platformUPer), let tokenS = Double(obj.tokenBalanceSort), let tokenU = Double(obj.tokenUPer) else {
            return
        }
        var isGray = false
        let amout = dTxt
        self.totalLabel.text = "\(amout)" + " " + symbol
        if self.contract.count == 0 {
            if amout > platB {
                changeSendBtnStatus(status: false)
                return
            }

            if platU <= 0 {
                self.numLabel.isHidden = true
                self.gasNumLabel.isHidden = true
                amoutTxtFiled.snp.remakeConstraints { make in
                    make.leading.equalTo(8)
                    make.centerY.equalTo(amoutView.snp.centerY)
                    make.width.equalTo(150)
                    make.height.equalTo(28)
                }
            } else {
                self.numLabel.isHidden = false
                self.gasNumLabel.isHidden = false
                amoutTxtFiled.snp.remakeConstraints { make in
                    make.leading.equalTo(8)
                    make.top.equalTo(12)
                    make.width.equalTo(150)
                    make.height.equalTo(28)
                }
                self.numLabel.text = "$\(platU*dTxt)"
                self.gasNumLabel.text = "$\(gas*platU)"
            }
            
            if amout == 0 || amout+gas > platB || obj.transType == 0 {
                isGray = false
            } else {
                isGray = true
            }
            
        } else {
            if amout > tokenS {
                changeSendBtnStatus(status: false)
                return
            }
            if tokenU <= 0 {
                self.numLabel.isHidden = true
                self.gasNumLabel.isHidden = true
                amoutTxtFiled.snp.remakeConstraints { make in
                    make.leading.equalTo(8)
                    make.centerY.equalTo(amoutView.snp.centerY)
                    make.width.equalTo(150)
                    make.height.equalTo(28)
                }
            } else {
                amoutTxtFiled.snp.remakeConstraints { make in
                    make.leading.equalTo(8)
                    make.top.equalTo(12)
                    make.width.equalTo(150)
                    make.height.equalTo(28)
                }
                self.numLabel.isHidden = false
                self.gasNumLabel.isHidden = false
                self.numLabel.text = "$\(tokenU*dTxt)"
                self.gasNumLabel.text = "$\(gas*platU)"
            }
            
            if amout == 0 || amout > tokenS || obj.transType == 0{
                isGray = false
            } else {
                isGray = true
            }
            
        }
        changeSendBtnStatus(status: isGray)
        
        if addressTxtView.text.count <= 0 {
            changeSendBtnStatus(status: false)
        }
    }
    
    
    
    
    @objc func textDidChange(_ textField:UITextField) {
        print("event:\(textField.text)")
        if let txt = textField.text {
            isAmountAll = false
            guard let obj = self.transactionModel else {
                return
            }
            
            if txt.count > 0 {
                clearBtn.isHidden = false
            } else {
                clearBtn.isHidden = true
            }
            
            if contract.count == 0 {
                let decimalTxt = NSDecimalNumber(string: txt)
                let decimalGas = NSDecimalNumber(string: obj.gas)
                let decimalFee = NSDecimalNumber(string: obj.tokenMinimum)
                let decimalPlat = NSDecimalNumber(string: obj.platformBalanceSort)
                
                if let dTxt = Double(txt), let gas = Double(obj.gas) {
                    if decimalTxt.compare(decimalPlat.subtracting(decimalGas)) == ComparisonResult.orderedDescending {
                        changeSendBtnStatus(status: false)
                        return
                    }
                 changeStatus(dTxt: dTxt, gas: gas)
                }
                return
            }
            
            
            if let dTxt = Double(txt), let gas = Double(obj.gas), let fee = Double(obj.tokenMinimum) {
                if dTxt <= fee {
                    changeSendBtnStatus(status: false)
                    return
                }
             changeStatus(dTxt: dTxt, gas: gas)
            }
            
        }
    }
    
    @objc func textDidEnd(_ textField:UITextField) {
        print("event:\(textField.text)")
        if let txt = textField.text {
            guard let obj = self.transactionModel else {
                return
            }
            
            let decimalTxt = NSDecimalNumber(string: txt)
            let decimalGas = NSDecimalNumber(string: obj.gas)
            let decimalFee = NSDecimalNumber(string: obj.tokenMinimum)
            
            if contract.count == 0 {
                let decimalPlat = NSDecimalNumber(string: obj.platformBalanceSort)
                
                if let dTxt = Double(txt), let gas = Double(obj.gas), let fee = Double(obj.tokenMinimum) {
                    if (dTxt <= fee && !isShowBalance) && decimalTxt.compare(decimalPlat.subtracting(decimalGas)) == ComparisonResult.orderedDescending {
                        isShowBalance = true
                        let toast = Go23Toast.init(frame: .zero)
                        toast.show("Insufficient balance", after: 1)
                        changeSendBtnStatus(status: false)
                        return
                    }
                    isShowBalance = false
                 changeStatus(dTxt: dTxt, gas: gas)
                }

                return
            }
            
            
            if let dTxt = Double(txt), let gas = Double(obj.gas), let fee = Double(obj.tokenMinimum) {
                if dTxt <= fee, !isShowBalance {
                    isShowBalance = true
                    let toast = Go23Toast.init(frame: .zero)
                    toast.show("Insufficient balance", after: 1)
                    changeSendBtnStatus(status: false)
                    return
                }
                isShowBalance = false
             changeStatus(dTxt: dTxt, gas: gas)
            }
            
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
    
    func filled(cover: String, name: String, chainId: Int, symbol: String, contract: String) {
        self.headerView.filled(cover: cover, name: name)
        self.chainName = name
        typeLabel.text = symbol
        amoutTypeLabel.text = symbol
        fromBtn.setAttributedTitle(getAttri(str: String.getSecretString(token: Go23WalletMangager.shared.address)), for: .normal)
        self.chainId = chainId
        self.symbol = symbol
        self.contract = contract
        transactionInfo()
        guard let url = URL(string: cover) else {
            return
        }
        DispatchQueue.global().async {
            do {
                self.imageData = try Data(contentsOf: url)
            }catch let error as NSError {
                print(error)
            }
        }
        
    }
    

}
