//
//  NavigationTitleView.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/21.
//

import UIKit

class NavigationTitleView : UIStackView {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "greenp_logo", in: Bundle.module, with: nil))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "greenp"
        label.font = .nanumSquare(size: 22, family: .bold)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("Never Will Happen")
    }
    
    private func configure() {
        initView()
        setupLayoutConstraints()
        setupActions()
    }
    
    private func initView() {
        spacing = 10
        axis = .horizontal
    }
    
    private func setupLayoutConstraints() {
        addArrangedSubview(logoImageView)
        addArrangedSubview(titleLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
    }
    
    private func setupActions() {
    }

}
