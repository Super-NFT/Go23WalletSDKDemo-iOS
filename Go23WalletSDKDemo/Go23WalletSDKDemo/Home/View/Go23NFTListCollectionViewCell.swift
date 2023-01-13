//
//  Go23NFTListCollectionViewCell.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/4.
//

import UIKit

class Go23NFTListCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        contentView.backgroundColor = .white
        contentView.addSubview(coverImgv)
        contentView.addSubview(titleLabel)
        coverImgv.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.width.height.equalTo((ScreenWidth-40-8)/2.0)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(coverImgv.snp.bottom).offset(8)
            make.leading.equalTo(00)
            make.trailing.equalTo(-20)
            make.height.equalTo(24)
        }
    }
    
    
    func filled(cover: String, title: String) {
        coverImgv.sd_setImage(with: URL(string: cover), placeholderImage: UIImage(named: "holder"))
        titleLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#000000"),alignment: .left, title: title)
    }
    
    private lazy var coverImgv: UIImageView = {
        let imgv = UIImageView()
        imgv.layer.cornerRadius = 8.0
        return imgv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 16)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#000000")
        return label
    }()
    
}
