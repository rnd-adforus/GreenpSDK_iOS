//
//  TagCollectionViewCell.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit
import SnapKit

struct TagCellConfig {
    var tag: String
    var key: String
    var isSelected: Bool = false
}

extension TagCell {
    public func configure(_ data: TagCellConfig, indexPath: IndexPath) {
        self.label.text = data.tag
        self.indexPath = indexPath
        self.label.sizeToFit()
        contentView.backgroundColor = data.isSelected ? UserInfo.shared.subThemeColor : UserInfo.shared.subThemeColor.withAlphaComponent(0.8)
    }
}

/// 태그 셀
class TagCell : UICollectionViewCell, CollectionViewCellReusable {
    private var indexPath: IndexPath?

    public lazy var label: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(size: 10, family: .bold)
        label.textColor = .white
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Never Will Happen")
    }
    
    private func setup() {
        setupLayoutConstraints()
        setupView()
        setupActions()
    }
    
    private func setupLayoutConstraints() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func setupView() {
        contentView.backgroundColor = UserInfo.shared.subThemeColor
        contentView.layer.cornerRadius = 6
    }

    private func setupActions() {
    }
    
    func sizeFittingWith(cellHeight: CGFloat, text: String) -> CGSize {
        label.text = text
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width + 20, height: cellHeight)
        return self.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
}

