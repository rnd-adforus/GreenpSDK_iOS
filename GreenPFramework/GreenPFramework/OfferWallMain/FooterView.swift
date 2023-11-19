//
//  FooterView.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/18.
//

import UIKit

class FooterView : UIView {
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
        setupActions()
    }
    
    private func initView() {
        backgroundColor = .gray
    }
    
    private func setupLayoutConstraints() {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .top
            stackView.distribution = .fill
            return stackView
        }()
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .nanumSquare(size: 10)
            label.textColor = .white
            label.text = " ・ 개인정보 처리방침"
            return label
        }()
        let versionLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .right
            label.font = .nanumSquare(size: 10)
            label.textColor = .white
            label.text = "by Adforus ver 3.1.0"
            return label
        }()
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(2)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(versionLabel)
    }
    
    private func setupActions() {
    }

}
