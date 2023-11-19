//
//  CircleProgressView.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/19.
//

import UIKit

extension CircleProgressView {
    public func set(time: Int, passedTime: Int) {
        label.text = "해당 기사를 \(time/1000)초 이상 시청하시면, 리워드가 지급됩니다.\n(현재 시청 시간: \(passedTime/1000)초)"
        progressView.setValue(CGFloat(passedTime) / CGFloat(time))
    }
    
    public func stop() {
        progressView.isHidden = true
        label.text = "적립 완료"
        label.textColor = .white
        backgroundColor = UserInfo.shared.themeColor
    }
}

class CircleProgressView : UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    private let progressView = CircleProgressbar()
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .nanumSquare(size: 12, family: .regular)
        label.numberOfLines = 0
        label.textColor = UserInfo.shared.themeColor
        label.textAlignment = .center
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
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderColor = UserInfo.shared.themeColor.cgColor
        layer.borderWidth = 0.5
    }
    
    private func setupLayoutConstraints() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        stackView.addArrangedSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.width.equalTo(progressView.snp.height)
        }
        stackView.addArrangedSubview(label)
    }
    
    private func setupActions() {
    }
}

import UIKit

extension CircleProgressbar {
    public func setValue(_ value: CGFloat) {
        progressLayer?.removeFromSuperlayer()
        progressLayer = makeMask(with: value)
    }
}
class CircleProgressbar: UIView {
    private let lineWidth: CGFloat = 5
    private var progressLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        setupMask()
    }
    
    func setup() {
        backgroundColor = .clear
    }
    
    private func setupMask() {
        let halfSize = bounds.size.width / 2
        let path = UIBezierPath(arcCenter: CGPoint(x: halfSize, y: halfSize),
                                radius: CGFloat(halfSize - (lineWidth/2)),
                                startAngle: CGFloat(0),
                                endAngle: .pi * 2,
                                clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.lineWidth = lineWidth

        layer.addSublayer(shapeLayer)
    }

    private func makeMask(with value: CGFloat) -> CAShapeLayer {
        let halfSize = bounds.size.width / 2
        let path = UIBezierPath(arcCenter: CGPoint(x: halfSize, y: halfSize),
                                radius: CGFloat(halfSize - (lineWidth/2)),
                                startAngle: .pi / 2 * 3,
                                endAngle: .pi * value * 2 + .pi / 2 * 3,
                                clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UserInfo.shared.themeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        layer.addSublayer(shapeLayer)
        return shapeLayer
    }
}
