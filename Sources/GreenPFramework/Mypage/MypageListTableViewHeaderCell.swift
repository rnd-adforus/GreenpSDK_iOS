//
//  MypageListTableViewHeaderCell.swift
//
//
//  Created by 신아람 on 1/8/24.
//

import UIKit
import SnapKit
import Kingfisher

struct MypageCellConfig {
    var id: String
    var name: String
    var date: String
    var imageURL: String?
    var reward: Int
    var pointType: String
    var content: String
    var buttonTitle: String?
    var isParticipateList: Bool
    var isHidden: Bool
    
    init(participate: ParticipateList.Participate) {
        self.id = String(participate.id)
        self.name = participate.name
        
        if(participate.rwdStatus == "적립완료") {
            self.reward = participate.price!
            self.date = participate.rwdDay
            self.pointType = participate.pointType
        } else {
            self.reward = 0
            self.date = ""
            self.pointType = ""
        }
        
        self.imageURL = participate.iconURLStr
        self.buttonTitle = participate.rwdStatus
        self.content = ""
        self.isParticipateList = true
        self.isHidden = true
    }
    
    init(cs: CsList.Cs) {
        self.id = cs.id
        self.name = cs.name
        self.date = cs.regDate
        self.reward = cs.price
        self.pointType = cs.priceType
        self.imageURL = cs.iconImg
        
        if(self.reward == 0) {
            self.pointType = ""
        }
        
        if(!cs.answer.isEmpty) {
            
            var txt = cs.content
            txt += "\n\n"
            txt += "[답변일자]\(cs.answerDate)"
            txt += "\n"
            txt += "[답변내용]"
            txt += "\n"
            txt += cs.answer
            
            self.content = txt
        } else {
            self.content = cs.content
        }
        
        self.buttonTitle = cs.status
        self.isParticipateList = false
        self.isHidden = true
    }
}

extension MypageListTableViewHeaderCell {
    func configure(_ data: MypageCellConfig) {
        feedInfoView.configure(title: data.name, content: data.date, reward: data.reward, point: data.pointType)
        if let url = data.imageURL {
            iconImageView.kf.setImage(with: URL(string: url))
        }
        if let buttonTitle = data.buttonTitle {
            button.setTitle(buttonTitle, for: .normal)
            
            
            if(data.isParticipateList) {
                if(buttonTitle != "적립완료") {
                    button.backgroundColor = .gray
                    button.titleLabel?.textColor = .white
                }
            } else {
                if(buttonTitle != "답변완료") {
                    button.backgroundColor = .gray
                    button.titleLabel?.textColor = .white
                }
            }
            
            button.isHidden = false
        } else {
            button.isHidden = true
        }
        
        if(data.isParticipateList) {
            updateUIOnParticipate()
        } else {
            updateUIOnCs()
        }
    }
    
    func setOpened(opened: Bool) {
        bottom.isHiddenn = opened
    }
}

class MypageListTableViewHeaderCell : UITableViewHeaderFooterView {
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    private let feedInfoView = FeedInfoView()
    private let button: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .nanumSquare(size: 14, family: .bold)
        button.titleLabel?.textColor = UserInfo.shared.fontColor
        button.backgroundColor = UserInfo.shared.btnColor
        button.layer.cornerRadius = 4
        button.isEnabled = false
        return button
    }()
    private let bottom = MypageInfoBottomView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("Never Will Happen")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupLayoutConstraints()
    }
    
    private func setupLayoutConstraints() {
        let bgView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        let verticalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = 10
            return stackView
        }()
        let horizontalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fillProportionally
            stackView.spacing = 10
            return stackView
        }()
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(5)
        }
        bgView.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        verticalStackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        horizontalStackView.addArrangedSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(iconImageView.snp.height)
        }
        horizontalStackView.addArrangedSubview(feedInfoView)
        feedInfoView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        horizontalStackView.addArrangedSubview(button)
        button.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        verticalStackView.addArrangedSubview(bottom)
    }
    
    private func updateUIOnParticipate() {
        bottom.isHidden = true
    }
    
    private func updateUIOnCs() {
        bottom.isHidden = false
        bottom.isHiddenn = true
    }
}
