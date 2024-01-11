//
//  MypageListTableViewBottomCell.swift
//  
//
//  Created by 신아람 on 1/8/24.
//

import UIKit
import SnapKit
import Kingfisher

extension MypageListTableViewBottomCell {
    func configure(_ data: MypageCellConfig) {
        contentLabel.text = data.content
    }
}

class MypageListTableViewBottomCell : UITableViewCell, TableViewCellReusable {
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(size: 13, family: .light)
        label.numberOfLines = 0 // 여러 줄의 텍스트 지원을 활성화
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Never Will Happen")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupLayoutConstraints()
    }
    
    private func setupLayoutConstraints() {
        addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(20)
        }
    }
}
