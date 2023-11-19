//
//  FeedInfoView.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/18.
//

import UIKit

extension FeedInfoView {
    public func configure(title: String, content: String, reward: Int) {
        titleLabel.text = title
        contentLabel.text = content
        rewardLabel.text = reward.commaString() + " 포인트"
    }
}

class FeedInfoView : UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(size: 15)
        return label
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(size: 13, family: .light)
        return label
    }()
    private let rewardLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UserInfo.shared.themeColor
        label.font = .nanumSquare(size: 15, family: .bold)
        return label
    }()
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
        backgroundColor = .clear
    }
    
    private func setupLayoutConstraints() {
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(rewardLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY).offset(-5)
        }
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(rewardLabel.snp.left).offset(-10)
            make.top.equalTo(self.snp.centerY).offset(5)
        }
        rewardLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.top)
            make.right.equalToSuperview()
        }
    }
    
    private func setupActions() {
    }
}
