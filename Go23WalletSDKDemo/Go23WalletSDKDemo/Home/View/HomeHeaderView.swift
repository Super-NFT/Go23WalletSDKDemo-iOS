//
//  HomeHeaderView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/2.
//

import Foundation
import UIKit
import Kingfisher

protocol HomeHeaderViewDelegate: AnyObject {
    func chooseClick()
    func receiveBtnClick()
    func sendBtnClick()
    func settingBtnClick()
    
}

class HomeHeaderView: UIView {
    
    static var cellHight = 420.0
    private var email = ""
    weak var delegate: HomeHeaderViewDelegate?
    
    var token = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F9F9F9")
        addSubview(rightBtn)
        addSubview(chooseV)
        addSubview(iconImgv)
        addSubview(emailLabel)
        addSubview(tokenLabel)
        addSubview(tokenControl)
        addSubview(numLabel)
        addSubview(titleLabel)
        addSubview(receiveBtn)
        addSubview(sendBtn)
        addSubview(lineV)
        
        rightBtn.snp.makeConstraints { make in
            make.top.equalTo(44)
            make.trailing.equalTo(0)
            make.width.height.equalTo(44)
        }
        chooseV.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.top.equalTo(rightBtn.snp.bottom).offset(10)
            make.height.equalTo(36)
            make.width.equalTo(120)
        }
        chooseV.isHidden = true
        iconImgv.snp.makeConstraints { make in
            make.centerY.equalTo(chooseV.snp.centerY)
            make.leading.equalTo(20)
            make.width.height.equalTo(28)
        }
        emailLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImgv.snp.right).offset(4)
            make.centerY.equalTo(iconImgv.snp.centerY)
        }
        emailLabel.isHidden = true
        tokenLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImgv.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
            make.width.equalTo(134)
        }
        tokenControl.snp.makeConstraints { make in
            make.center.equalTo(tokenLabel.snp.center)
            make.height.equalTo(35)
            make.width.equalTo(134)
        }
        
        numLabel.snp.makeConstraints { make in
            make.top.equalTo(tokenLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.height.equalTo(36)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(numLabel.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
        }
        
        receiveBtn.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.width.equalTo(82.5)
            make.height.equalTo(77)
            make.left.equalTo(numLabel.snp.centerX).offset(-100)
        }
        
        sendBtn.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.width.equalTo(82.5)
            make.height.equalTo(77)
            make.right.equalTo(numLabel.snp.centerX).offset(100)
        }
        
        lineV.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    func filled(cover: String, email: String) {
        iconImgv.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        iconImgv.layer.cornerRadius = 14
        self.email = email
    }
    
    func filled(money: String, symbol: String, chainName: String, balanceU: String) {
        var ee = email
        if email.count > 17 {
            ee = email.substring(to: 15) + "..."
        }
        
        let emailWidth = ScreenWidth-getRowWidth(desc: chainName)-20-52
        if getStringWidth(email, lineHeight:  16.0, font: UIFont(name: BarlowCondensed, size: 14) ?? UIFont.systemFont(ofSize: 14)) <= emailWidth {
            ee = email
        }
        emailLabel.isHidden = false
        
        emailLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 14), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .left, title: ee)
        var mon = money
        var bal = balanceU
        if let ss = Double(money), ss <= 0 {
            mon = "0.00"
        }
        numLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensedBold, size: 36), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: mon + " " + symbol)
        chooseV.isHidden = false
        chooseV.snp.remakeConstraints() { make in
            make.trailing.equalTo(-20)
            make.top.equalTo(rightBtn.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(getRowWidth(desc: chainName))
        }
        emailLabel.snp.remakeConstraints() { make in
            make.left.equalTo(iconImgv.snp.right).offset(4)
            make.centerY.equalTo(iconImgv.snp.centerY)
            make.width.equalTo(emailWidth)
        }
        if let bb = Double(balanceU), bb <= 0 {
            bal = "0.00"
        }
        titleLabel.text = "$"+bal
    }
    
    func getRowWidth(desc: String) -> CGFloat {
        return getStringWidth(desc, lineHeight:  16.0, font: UIFont(name: BarlowCondensed, size: 14) ?? UIFont.systemFont(ofSize: 14))  + 66.0
    }
    
    private func getStringWidth(_ content: String,
                                 lineHeight:CGFloat = 27.0,
                                 font: UIFont = UIFont.systemFont(ofSize: 14),
                                 wordWidth: CGFloat = (ScreenWidth - 40.0)) -> CGFloat {
        let paraph = NSMutableParagraphStyle()
        paraph.maximumLineHeight = lineHeight
        paraph.minimumLineHeight = lineHeight
        let attributes = [NSAttributedString.Key.paragraphStyle: paraph, NSAttributedString.Key.font: font, NSAttributedString.Key.kern: 0.5] as [NSAttributedString.Key : Any]

        let rowHeight = (content.trimmingCharacters(in: .newlines) as NSString).boundingRect(with: CGSize(width: wordWidth, height: 0), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: attributes, context: nil).size.width
         return rowHeight
     }
    
    func filled(address: String) {
        self.token = address
        let str = String.getSecretString(token: token)
        
        let attri = NSMutableAttributedString()
        attri.add(text: str) { attr in
            attr.font(14)
            attr.color(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"))
        }.add(text: " ") { att in
            
        }
        
        attri.addImage("copy", CGRectMake(0, 0, 12, 12))
        tokenLabel.attributedText = attri
        tokenLabel.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#EBF5F5")

    }
    
    @objc private func settingBtnDidClick() {
        self.delegate?.settingBtnClick()
    }
    
    @objc private func controlClick() {
        UIPasteboard.general.string = self.token
        let toast = Go23Toast.init(frame: .zero)
        toast.show("Copied!", after: 1)
    }
    
    @objc private func receiveBtnClick() {
        self.delegate?.receiveBtnClick()
    }
    
    @objc private func sendBtnClick() {
        self.delegate?.sendBtnClick()
    }
    
    
    private lazy var rightBtn: UIButton = {
        let rightBtn = UIButton()
        rightBtn.frame = CGRectMake(0, 0, 44, 44)
        let imgv = UIImageView()
        rightBtn.addSubview(imgv)
        imgv.image = UIImage.init(named: "rightDot")
        imgv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        rightBtn.addTarget(self, action: #selector(settingBtnDidClick), for: .touchUpInside)
        return rightBtn
    }()
    
    private lazy var iconImgv: UIImageView = {
        let imgv = UIImageView()
        
        return imgv
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    lazy var chooseV: ChooseView = {
        let view = ChooseView()
        view.clickBlock = { [weak self] in
            self?.delegate?.chooseClick()
        }
        return view
    }()
    
    private lazy var tokenLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.layer.cornerRadius = 17.5
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    private lazy var tokenControl: UIControl = {
        let control = UIControl()
        control.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
        return control
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "$0.00"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    private lazy var numLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: BarlowCondensed, size: 32)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.text = "0.00"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var receiveBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "scan"), for: .normal)
        btn.setTitle("Receive", for: .normal)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"), for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layoutButtonEdgeInsets(style: .imageTop, margin: 20.0)
        btn.addTarget(self, action: #selector(receiveBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var sendBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Send", for: .normal)
        btn.setImage(UIImage.init(named: "send"), for: .normal)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"), for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layoutButtonEdgeInsets(style: .imageTop, margin: 20.0)
        btn.addTarget(self, action: #selector(sendBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var lineV: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        return view
    }()
    
}


class ChooseView: UIView {
    
    public var clickBlock: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        
        addSubview(iconImgv)
        addSubview(titleLabel)
        addSubview(control)
        
        iconImgv.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImgv.snp.right).offset(0)
            make.trailing.equalTo(-10)
        }
        
        control.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func filled(title: String, img: String) {
        
        iconImgv.kf.setImage(with: URL(string: img))
        let attri = NSMutableAttributedString()
        attri.add(text: " ") { attr in
            
        }
        attri.add(text: title) { attr in
            attr.customFont(14, BarlowCondensed)
            attr.color(UIColor.rdt_HexOfColor(hexString: "#262626"))
            attr.kern(0.5)
        }
        attri.add(text: " ") { attr in
            
        }
        attri.addImage("arrowDown", CGRectMake(0, 0, 12, 12))
        titleLabel.attributedText = attri
        
        layer.masksToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
    }
    
    
    @objc private func controlClick() {
        self.clickBlock?()
    }
    
    private lazy var iconImgv: UIImageView = {
        let imgv = UIImageView()
        
        return imgv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 16)
        label.textAlignment = .center
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
