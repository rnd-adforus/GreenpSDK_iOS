//
//  PageControlView.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit
import SnapKit

protocol PageControlViewDelegate : AnyObject {
    func didTapPageControlAt(index: Int)
}
class PageControlView : UIView {
//    public var buttonTitles: [String] = [] {
//        didSet {
//            configure()
//            setSelected(index: 0)
//        }
//    }
    private var buttons: [UIButton] = []
    private var barView: UIView!
    private var selectedIndex: Int = 0
    weak var delegate: PageControlViewDelegate?

    convenience init(delegate: PageControlViewDelegate) {
        self.init()
        self.delegate = delegate
        configure()
        animateBarView(selectedIndex: 0, animated: false)
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
        configureBarView()
    }

    // 버튼 구성
    private func createButtons() {
        for title in UserInfo.shared.tabs.map({ $0.name }) {
            let button = UIButton()
            button.titleLabel?.font = .nanumSquare(size: 17, family: .extraBold)
            button.setTitleColor(.white.withAlphaComponent(0.8), for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(buttonHandler(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        for (i, button) in buttons.enumerated() {
            button.isSelected = i == 0
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
            stackView.alignment = .leading
            stackView.distribution = .equalSpacing
            stackView.spacing = 20
            return stackView
        }()
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        buttons.forEach{ $0.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }}
    }

    /// 애니메이션 바 구성 함수
    private func configureBarView() {
        barView = UIView(frame: .init(origin: .zero, size: .init(width: 60, height: 1)))
        barView.backgroundColor = .white
        addSubview(barView)
    }
    
    /// 버튼 선택 함수
    /// - parameter index : 버튼 인덱스
    private func setSelected(index: Int) {
        selectedIndex = index
        for (btnIdx, btn) in buttons.enumerated() {
            if btnIdx == index {
                btn.isSelected = true
                animateBarView(selectedIndex: btnIdx)
                delegate?.didTapPageControlAt(index: btnIdx)
            } else {
                btn.isSelected = false
            }
        }
    }
    
    private func animateBarView(selectedIndex: Int, animated: Bool = true) {
        let width = 60
        if animated {
            UIView.animate(withDuration: 0.25) {
                remakeConstraint()
                self.layoutIfNeeded()
            }
        } else {
            remakeConstraint()
        }
        func remakeConstraint() {
            self.barView.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().inset(1)
                make.height.equalTo(2)
                make.leading.equalTo(self.buttons[selectedIndex].snp.leading)
                make.width.equalTo(width)
            }
        }
    }
}
