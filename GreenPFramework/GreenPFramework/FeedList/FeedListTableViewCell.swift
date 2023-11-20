//
//  FeedListTableViewCell.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/15.
//

import UIKit
import SnapKit
import Kingfisher

struct FeedCellConfig {
    var id: String
    var name: String
    var contents: String
    var imageURL: String
    var type: FeedUIType
    var reward: Int
    var buttonTitle: String?
    
    init(feed: FeedList.Feed, buttonTitle: String) {
        self.id = feed.id
        self.name = feed.name
        self.contents = feed.subTitle
        self.type = feed.imageURLStr.isEmpty ? .list : .feed
        self.imageURL = feed.imageURLStr.isEmpty ? feed.iconURLStr : feed.imageURLStr
        self.reward = feed.reward
        self.buttonTitle = buttonTitle
    }
}

extension FeedListTableViewCell {
    func configure(_ data: FeedCellConfig) {
        feedInfoView.configure(title: data.name, content: data.contents, reward: data.reward)
        if data.type == .feed {
            feedImageView.kf.setImage(with: URL(string: data.imageURL))
            updateUIOnFeedMode()
        } else {
            iconImageView.kf.setImage(with: URL(string: data.imageURL))
            updateUIOnListMode()
        }
        if let buttonTitle = data.buttonTitle {
            button.setTitle(buttonTitle, for: .normal)
            button.isHidden = false
        } else {
            button.isHidden = true
        }
    }
}

class FeedListTableViewCell : UITableViewCell, TableViewCellReusable {
    private let feedImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
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
        button.backgroundColor = UserInfo.shared.themeColor
        button.layer.cornerRadius = 4
        button.isEnabled = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Never Will Happen")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        feedImageView.image = nil
        iconImageView.image = nil
        feedImageView.isHidden = true
        iconImageView.isHidden = true
    }
    
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupLayoutConstraints()
    }
    
    private func setupLayoutConstraints() {
        let bgView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        let verticalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.setContentHuggingPriority(.required, for: .vertical)
            stackView.spacing = 10
            return stackView
        }()
        let horizontalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fill
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
        
        verticalStackView.addArrangedSubview(feedImageView)
        verticalStackView.addArrangedSubview(horizontalStackView)
        feedImageView.snp.makeConstraints { make in
            make.width.equalTo(feedImageView.snp.height).multipliedBy(2).priority(.high)
        }
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
    }
    
    private func updateUIOnListMode() {
        feedImageView.isHidden = true
        iconImageView.isHidden = false
    }
    
    private func updateUIOnFeedMode() {
        feedImageView.isHidden = false
        iconImageView.isHidden = true
    }
}
