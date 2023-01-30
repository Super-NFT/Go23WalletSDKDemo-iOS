//
//  Go23TokenHeaderView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/6.
//

import UIKit

protocol TokenHeaderViewDelegate: AnyObject {
    func receiveBtnClick()
    func sendBtnClick()
    func leftBtnClick()
    
}

class Go23TokenHeaderView: UIView {
    weak var delegate: TokenHeaderViewDelegate?
    
    var token = ""
    
    static var cellHeight = 310.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F9F9F9")

        addSubview(titleLabel)
        addSubview(coverImgv)
        addSubview(sourceImgv)
        addSubview(leftBtn)
        addSubview(nameLabel)
        addSubview(numLabel)
        addSubview(moneyLabel)
        addSubview(receiveBtn)
        addSubview(sendBtn)

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(86)
            make.centerX.equalToSuperview()
            make.height.equalTo(14)
        }
        numLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        moneyLabel.snp.makeConstraints { make in
            make.top.equalTo(numLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
        receiveBtn.snp.makeConstraints { make in
            make.top.equalTo(moneyLabel.snp.bottom).offset(26)
            make.width.equalTo(82.5)
            make.height.equalTo(77)
            make.left.equalTo(numLabel.snp.centerX).offset(-100)
        }
        
        sendBtn.snp.makeConstraints { make in
            make.top.equalTo(moneyLabel.snp.bottom).offset(26)
            make.width.equalTo(82.5)
            make.height.equalTo(77)
            make.right.equalTo(numLabel.snp.centerX).offset(100)
        }
        
    }
    
    func filled(cover: String, type: String, name: String, num: String, money: String, sourceImg: String) {
        
        
        let paraph = NSMutableParagraphStyle()
        let attributes = [NSAttributedString.Key.paragraphStyle: paraph, NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 24), NSAttributedString.Key.kern: 0.5] as [NSAttributedString.Key : Any]
        let rowWidth = (type.trimmingCharacters(in: .newlines) as NSString).boundingRect(with: CGSize(width: ScreenWidth, height: 0), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: attributes, context: nil).size.width
                
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(54)
            make.centerX.equalToSuperview().offset(16)
            make.width.equalTo(rowWidth)
            make.height.equalTo(32)
        }
        coverImgv.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.centerX.equalToSuperview().offset(-(24.0))
        }
        sourceImgv.snp.makeConstraints { make in
            make.width.height.equalTo(8)
            make.bottom.equalTo(coverImgv.snp.bottom)
            make.right.equalTo(coverImgv.snp.right)
        }
        
        leftBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY).offset(10)
            make.left.equalToSuperview()
            make.width.height.equalTo(44)
        }
        coverImgv.sd_setImage(with: URL(string: cover), placeholderImage: nil)
        sourceImgv.sd_setImage(with: URL(string: sourceImg), placeholderImage: nil)
        titleLabel.text = type
        nameLabel.text = name
//        numLabel.text = "\(num)"
        numLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 32), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: "\(num)"+" "+type)
        moneyLabel.text = "$\(money)"
        if let mm = Double(money), mm <= 0 {
            moneyLabel.text = "$0.0"
        }
        
    }
    
    @objc private func leftBtnDidClick() {
        self.delegate?.leftBtnClick()
    }
    
    @objc private func receiveBtnClick() {
        self.delegate?.receiveBtnClick()
    }
    
    @objc private func sendBtnClick() {
        self.delegate?.sendBtnClick()
    }
    
    private lazy var coverImgv: UIImageView = {
        let imgv = UIImageView()
        
        return imgv
    }()
    private lazy var sourceImgv: UIImageView = {
        let imgv = UIImageView()
        
        return imgv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 24)
        label.textAlignment = .center
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var leftBtn: UIButton = {
        let btn = UIButton()
        btn.frame = CGRectMake(0, 0, 44, 44)
        let imgv = UIImageView()
        btn.addSubview(imgv)
        imgv.image = UIImage.init(named: "back")
        imgv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        btn.addTarget(self, action: #selector(leftBtnDidClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var numLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensedBold, size: 36)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var receiveBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "scan"), for: .normal)
        btn.setTitle("Receive", for: .normal)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#848484"), for: .normal)
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
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#848484"), for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layoutButtonEdgeInsets(style: .imageTop, margin: 20.0)
        btn.addTarget(self, action: #selector(sendBtnClick), for: .touchUpInside)
        return btn
    }()
    
}
