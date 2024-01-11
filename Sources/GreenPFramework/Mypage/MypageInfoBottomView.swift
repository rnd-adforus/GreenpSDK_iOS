//
//  MypageInfoBottomView.swift
//  
//
//  Created by 신아람 on 12/28/23.
//

import UIKit

class MypageInfoBottomView : UIView {
    private let txtLabel: UILabel = {
        let label = UILabel()
        label.text = "문의내역"
        label.font = .nanumSquare(size: 13, family: .light)
        return label
    }()
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "보기"
        label.textAlignment = .right
        label.font = .nanumSquare(size: 13, family: .light)
        return label
    }()
    private let infoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.isEnabled = false
        return button
    }()
    
    var isHiddenn: Bool = true {
        didSet {
            isHiddenn ? self.infoButton.setImage(UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate), for: .normal) : self.infoButton.setImage(UIImage(systemName: "chevron.up")?.withRenderingMode(.alwaysTemplate), for: .normal)
            
            infoButton.tintColor = .black
            
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Never Will Happen")
    }
    
    private func configure() {
        initView()
        setupLayoutConstraints()
    }
    
    private func initView() {
        backgroundColor = .clear
    }
    
    private func setupLayoutConstraints() {
        
        self.sizeToFit()
        
        addSubview(txtLabel)
        addSubview(infoLabel)
        addSubview(infoButton)
        
        txtLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        infoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(txtLabel)
            make.right.equalTo(infoButton.snp.left)
        }

        infoButton.snp.makeConstraints { make in
            make.centerY.equalTo(txtLabel)
            make.right.equalTo(self.snp.right).offset(10)
        }
    }
}
