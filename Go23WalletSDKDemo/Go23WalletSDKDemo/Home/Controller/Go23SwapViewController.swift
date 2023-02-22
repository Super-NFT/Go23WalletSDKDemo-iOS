//
//  Go23SwapViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/2/21.
//

import UIKit
import Kingfisher
import Go23SDK

class Go23SwapViewController: UIViewController {
    
    
    var fromChainName = Go23WalletMangager.shared.walletModel?.name ?? ""
    var tokenModel: Go23WalletTokenModel? {
        didSet {
            guard let model = tokenModel else {
                return
            }
            fromBtn.filled(img: model.imageUrl, block: model.symbol, name: fromChainName)
        }
    }
    
    var toChainName = ""
    var toModel: Go23WalletTokenModel? {
        didSet {
            guard let model = toModel else {
                return
            }
            toBtn.filled(img: model.imageUrl, block: model.symbol, name: toChainName)
        }
    }
    private var tenTimer: Timer?
    private var timer: Timer?
    private var timerProgress = 31.0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false

    }
    
    deinit {
        stopAnimating()
        removeTenTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        
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
            navgationBar?.title = "Swap"
            navgationBar?.attributes = [NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 20), NSAttributedString.Key.kern: 0.5] as [NSAttributedString.Key : Any]
            navgationBar?.leftBarItem = HBarItem.init(customView: backBtn)
        }
    }
    
    @objc private func backBtnDidClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func initSubviews() {
        self.view.backgroundColor = .white
        view.addSubview(fromV)
        fromV.addSubview(maxBtn)
        fromV.addSubview(fromBalanceLabel)
        fromV.addSubview(fromBtn)
        fromV.addSubview(fromAmoutTxtFiled)
        fromV.addSubview(fromMoneyLabel)
        view.addSubview(toV)
        toV.addSubview(toBalanceLabel)
        toV.addSubview(toBtn)
        toV.addSubview(toAmoutTxtFiled)
        toV.addSubview(toMoneyLabel)
        view.addSubview(exchangeBtn)
        view.addSubview(swapBtn)
        view.addSubview(feeV)
        feeV.addSubview(exchangeLabel)
        feeV.addSubview(feeExchangeBtn)
        feeV.addSubview(progressView)
        progressView.progress = 1.0
        feeV.addSubview(slippageTxt)
        feeV.addSubview(slippageLabel)
        feeV.addSubview(addressTxt)
        feeV.addSubview(addressBtn)
        feeV.addSubview(feeTxt)
        feeV.addSubview(feeLabel)
        
        
        fromV.snp.makeConstraints { make in
            make.top.equalTo(navgationBar!.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(120)
        }
        
        fromBtn.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(fromV.snp.top).offset(60)
            make.width.equalTo(115)
            make.height.equalTo(32)
        }
        maxBtn.snp.makeConstraints { make in
            make.right.equalTo(-5)
            make.top.equalTo(0)
            make.height.width.equalTo(44)
        }
        
        fromBalanceLabel.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.right.equalTo(maxBtn.snp.left).offset(5)
        }
        
        
        fromAmoutTxtFiled.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.left.equalTo(135)
            make.centerY.equalTo(fromBtn.snp.centerY)
            make.height.equalTo(32)
        }
        
        fromMoneyLabel.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.top.equalTo(fromAmoutTxtFiled.snp.bottom)
            make.height.equalTo(15)
        }
        
        toV.snp.makeConstraints { make in
            make.top.equalTo(fromV.snp.bottom).offset(2)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(120)
        }
        
        toBtn.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(toV.snp.top).offset(60)
            make.width.equalTo(115)
            make.height.equalTo(32)
        }
        
        toBalanceLabel.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.right.equalTo(-15)
        }
        
        toAmoutTxtFiled.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.left.equalTo(135)
            make.centerY.equalTo(toBtn.snp.centerY)
            make.height.equalTo(32)
        }
        
        toMoneyLabel.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.top.equalTo(toAmoutTxtFiled.snp.bottom)
            make.height.equalTo(15)
        }
        
        exchangeBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(fromV.snp.bottom).offset(-16)
        }
        
        swapBtn.snp.makeConstraints { make in
            make.top.equalTo(toV.snp.bottom).offset(40)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(48)
        }
        
        feeV.snp.makeConstraints { make in
            make.top.equalTo(swapBtn.snp.bottom).offset(13)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        exchangeLabel.snp.makeConstraints { make in
            make.top.equalTo(swapBtn.snp.bottom).offset(13)
            make.height.equalTo(17)
            make.centerX.equalToSuperview()
        }
        
        feeExchangeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(exchangeLabel.snp.centerY)
            make.height.width.equalTo(44)
            make.left.equalTo(exchangeLabel.snp.right).offset(-10)
        }
        
        progressView.snp.makeConstraints { (make) in
            make.centerY.equalTo(exchangeLabel.snp.centerY)
            make.right.equalTo(exchangeLabel.snp.left).offset(-10)
            make.width.height.equalTo(10)

        }
        
        slippageTxt.snp.makeConstraints { make in
            make.top.equalTo(exchangeLabel.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.height.equalTo(20)
        }
        
        slippageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(slippageTxt.snp.centerY)
            make.right.equalTo(-20)
            make.height.equalTo(20)
        }
        
        addressTxt.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(slippageTxt.snp.bottom).offset(16)
            make.height.equalTo(20)
        }
        
        addressBtn.snp.makeConstraints { make in
            make.centerY.equalTo(addressTxt.snp.centerY)
            make.right.equalTo(-20)
            make.height.equalTo(20)
        }
        
        feeTxt.snp.makeConstraints { make in
            make.top.equalTo(addressTxt.snp.bottom).offset(16)
            make.left.height.equalTo(20)
        }
        feeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(feeTxt.snp.centerY)
            make.right.equalTo(-20)
            make.height.equalTo(20)
        }
        
        
//        tenTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(tenTimerAction), userInfo: nil, repeats: true)

    }
    
    

    

    private lazy var fromV: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F7F7F7")
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.text = "From"
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.top.height.equalTo(15)
        }
        return view
        
    }()
    
    private lazy var fromBtn: Go23SwapChangeBtn = {
        let btn = Go23SwapChangeBtn.init(frame: .zero)
        btn.clickBlock = { [weak self] in
            let alert = Go23SwipSelectView.init(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight-120))
            let ovc = OverlayController(view: alert)
            ovc.maskStyle = .black(opacity: 0.4)
            ovc.layoutPosition = .bottom
            ovc.presentationStyle = .fromToBottom
            ovc.isDismissOnMaskTouched = false
            ovc.isPanGestureEnabled = false
            alert.closeBlock = { [weak self] in
                self?.view.dissmiss(overlay: .last)
            }
            self?.view.present(overlay: ovc)
        }
        
        return btn
    }()
    
    private lazy var maxBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("MAX", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#00CBD6"), for: .normal)
        btn.addTarget(self, action: #selector(maxBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var fromBalanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#6F6D6D")
        label.text = "Balance: 0.00"
        return label
    }()
    
    private lazy var fromAmoutTxtFiled: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont.boldSystemFont(ofSize: 24)
        textfield.addTarget(self, action: #selector(textDidEnd(_ :)), for: .editingDidEnd)
        let attributes = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24) as Any,  NSAttributedString.Key.foregroundColor:UIColor.rdt_HexOfColor(hexString: "#BFBFBF")] as [NSAttributedString.Key : Any]
        let attri = NSAttributedString(string: "0.00", attributes: attributes as [NSAttributedString.Key : Any])
        textfield.attributedPlaceholder = attri
        textfield.addTarget(self, action: #selector(textDidEnd(_ :)), for: .editingDidEnd)
        textfield.tintColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        textfield.keyboardType = UIKeyboardType.decimalPad
        textfield.textAlignment = .right
        return textfield
    }()
    
    private lazy var fromMoneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .right
        label.text = "$0.00"
        return label
    }()
    
    private lazy var toV: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F7F7F7")
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.text = "To"
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.top.height.equalTo(15)
        }
        return view
        
    }()
    
    private lazy var toBtn: Go23SwapChangeBtn = {
        let btn = Go23SwapChangeBtn.init(frame: .zero)
        btn.filled(img: "", block: "", name: "")
        btn.clickBlock = { [weak self] in
            let alert = Go23SwipSelectView.init(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight-120))
            let ovc = OverlayController(view: alert)
            ovc.maskStyle = .black(opacity: 0.4)
            ovc.layoutPosition = .bottom
            ovc.presentationStyle = .fromToBottom
            ovc.isDismissOnMaskTouched = false
            ovc.isPanGestureEnabled = false
            
            alert.closeBlock = { [weak self] in
                self?.view.dissmiss(overlay: .last)
            }
            
            self?.view.present(overlay: ovc)
        }
        return btn
    }()
    
    private lazy var toBalanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#6F6D6D")
        label.text = "Balance: 0.00"
        return label
    }()
    
    private lazy var toAmoutTxtFiled: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont.boldSystemFont(ofSize: 24)
        let attributes = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24) as Any,  NSAttributedString.Key.foregroundColor:UIColor.rdt_HexOfColor(hexString: "#BFBFBF")] as [NSAttributedString.Key : Any]
        let attri = NSAttributedString(string: "0.00", attributes: attributes as [NSAttributedString.Key : Any])
        textfield.attributedPlaceholder = attri
        textfield.addTarget(self, action: #selector(textDidEnd(_ :)), for: .editingDidEnd)
        textfield.tintColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        textfield.textAlignment = .right
        textfield.keyboardType = UIKeyboardType.decimalPad
        return textfield
    }()
    
    private lazy var toMoneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .right
        label.text = "$0.00"
        return label
    }()
    
    private lazy var exchangeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "swapBlue"), for: .normal)
        btn.addTarget(self, action: #selector(exchangeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var swapBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Swap", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 20)
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 12
        btn.addTarget(self, action: #selector(swapBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var exchangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#595959")
        return label
    }()
    
    private lazy var progressView: Go23CircleView = {
        let progress = Go23CircleView(gradient: [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1)], colors: [UIColor.white,UIColor.white], backColor: UIColor.rdt_HexOfColor(hexString: "#989898"), lineWidth: 2.0)
        progress.backgroundColor = .clear
        progress.isHidden = true
        return progress
    }()
    
    private lazy var feeExchangeBtn: UIButton = {
        let btn = UIButton()
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "exchange")
        btn.addSubview(imgv)
        imgv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(12)
        }
        btn.addTarget(self, action: #selector(exchangeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var feeV: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var slippageTxt: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Slippage"
        return label
    }()
    
    private lazy var slippageLabel: UILabel = {
        let label = UILabel()
        label.text = "Auto"
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var addressTxt: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Receiving address"
        return label
    }()
    
    private lazy var addressBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"), for: .normal)
        btn.titleLabel?.textAlignment = .right
        btn.addTarget(self, action: #selector(addressBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var feeTxt: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Tx fee"
        return label
    }()
    
    private lazy var feeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    

}

//Action
extension Go23SwapViewController {
    
    @objc private func maxBtnClick() {
        
    }
    
    @objc private func addressBtnClick() {
        UIPasteboard.general.string = Go23WalletMangager.shared.address
        let toast = Go23Toast.init(frame: .zero)
        toast.show("Copied!", after: 1)
    }
    
    @objc func tenTimerAction() {
        startAction()
    }
    
    private func startAction() {
        if timer == nil {
            progressView.setProgress(1.0)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func timerAction() {
        progressView.isHidden = false
        timerProgress -= 1
        let progress = Float(timerProgress / 30.0)
        progressView.setProgress(progress, animated: true)
        if timerProgress <= 0 {
            stopAnimating()
            progressView.setProgress(0, animated: true)
            progressView.isHidden = true
            return
        }
    }
    
    
    func stopAnimating() {
        if self.timer != nil {
            self.timerProgress = 31
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func removeTenTimer() {
        if self.tenTimer != nil {
            self.tenTimer?.invalidate()
            self.tenTimer = nil
        }
    }
    
    @objc func textDidEnd(_ textField:UITextField) {
        if let txt = textField.text {
        }
    }
    
    @objc private func swapBtnClick() {
        
    }
    
    @objc private func exchangeBtnClick() {
        guard toModel != nil else {
            return
        }
        
    }
    
    
}







class Go23SwapChangeBtn: UIView {
    
    var clickBlock: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews() {
        addSubview(iconImgv)
        addSubview(blockLabel)
        addSubview(nameLabel)
        addSubview(downImgv)
        addSubview(control)
        
        iconImgv.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.height.width.equalTo(32)
        }
        blockLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImgv.snp.right).offset(10)
            make.top.equalToSuperview().offset(-4)
            make.height.equalTo(22)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(blockLabel.snp.bottom)
            make.left.equalTo(iconImgv.snp.right).offset(10)
            make.width.equalTo(62)
            make.height.equalTo(15)
        }
        
        downImgv.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.height.equalTo(12)
            make.width.equalTo(12)
            make.centerY.equalToSuperview()
        }
        
        control.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func filled(img: String, block: String, name: String) {
        if img.count == 0 {
            iconImgv.isHidden = true
            nameLabel.isHidden = true
            blockLabel.text = "Select token"
            blockLabel.snp.remakeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.equalTo(22)
                make.left.equalTo(0)
            }
        } else {
            blockLabel.snp.makeConstraints { make in
                make.left.equalTo(iconImgv.snp.right).offset(10)
                make.top.equalToSuperview().offset(-4)
                make.height.equalTo(22)
            }
            iconImgv.isHidden = false
            iconImgv.kf.setImage(with: URL(string: img))
            nameLabel.isHidden = false
            blockLabel.text = block
            nameLabel.text = name
        }
        
        
    }
    
    @objc private func controlClick() {
        self.clickBlock?()
    }
    
    
    private lazy var iconImgv: UIImageView = {
        let imgv = UIImageView()
        imgv.layer.masksToBounds = true
        imgv.layer.cornerRadius = 16
        imgv.layer.masksToBounds = true
        imgv.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#F0F0F0").cgColor
        imgv.layer.borderWidth = 1
        return imgv
    }()
    
    private lazy var blockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var downImgv: UIImageView = {
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "arrowDown")
        return imgv
    }()
    
    private lazy var control: UIControl = {
        let control = UIControl()
        control.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
        return control
    }()
    
}
