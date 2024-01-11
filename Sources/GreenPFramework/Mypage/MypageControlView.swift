//
//  MypageControlViewDelegate.swift
//  
//
//  Created by 신아람 on 12/13/23.
//

import UIKit
import SnapKit

protocol MypageControlViewDelegate : AnyObject {
    func didTapPageControlAt(index: Int)
}
class MypageControlView : UIView {
    private let tabs = ["광고 참여 내역", "문의 내역"]
    
    private var buttons: [UIButton] = []
    private var selectedIndex: Int = 0
    weak var delegate: MypageControlViewDelegate?

    convenience init(delegate: MypageControlViewDelegate) {
        self.init()
        self.delegate = delegate
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Never Will Happen")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    func configure() {
        createButtons()
        configureStackView()
    }

    // 버튼 구성
    private func createButtons() {
        for title in tabs.map({ $0 }) {
            let button = UIButton()
            button.titleLabel?.font = .nanumSquare(size: 14, family: .extraBold)
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(buttonHandler(_:)), for: .touchUpInside)
            
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            
            buttons.append(button)
        }
        for (i, button) in buttons.enumerated() {

            if(i == 0) {
                button.isSelected = true
                button.backgroundColor = UserInfo.shared.btnColor
            } else {
                button.isSelected = false;
                button.backgroundColor = .gray
            }
        }
    }
    
    @objc private func buttonHandler(_ sender: UIButton) {
        if let index = buttons.firstIndex(of: sender) {
            setSelected(index: index)
        }
    }

    // 스택 뷰 구성
    private func configureStackView() {
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: buttons)
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            stackView.spacing = 20
            return stackView
        }()
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
        buttons.forEach{ $0.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }}
    }
    
    /// 버튼 선택 함수
    /// - parameter index : 버튼 인덱스
    private func setSelected(index: Int) {
        selectedIndex = index
        for (btnIdx, btn) in buttons.enumerated() {
            if btnIdx == index {
                btn.isSelected = true
                btn.backgroundColor = UserInfo.shared.themeColor
                delegate?.didTapPageControlAt(index: btnIdx)
            } else {
                btn.isSelected = false
                btn.backgroundColor = .gray
            }
        }
    }
}
