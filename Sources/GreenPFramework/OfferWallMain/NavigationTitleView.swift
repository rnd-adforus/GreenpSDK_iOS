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
        label.text = UserInfo.shared.title
        label.font = .nanumSquare(size: 18, family: .bold)
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
        spacing = 5
        axis = .horizontal
    }
    
    private func setupLayoutConstraints() {
        if(UserInfo.shared.iconView == "Y"){
            addArrangedSubview(logoImageView)
            logoImageView.snp.makeConstraints { make in
                make.size.equalTo(25)
            }
        }else{
            logoImageView.removeFromSuperview()
        }
        addArrangedSubview(titleLabel)
       
    }
    
    private func setupActions() {
    }

}
