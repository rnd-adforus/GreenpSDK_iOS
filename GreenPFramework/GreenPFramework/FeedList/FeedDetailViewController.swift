//
//  FeedDetailViewController.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/18.
//

import UIKit
import Kingfisher

class FeedDetailViewController : BaseViewController {
    public var detailViewModel: DetailViewModel!
    
    // MARK: Object lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Never Will Happen")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Setup UI properties
    
    private let feedImageView: PaddingImageView = {
        let view = PaddingImageView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
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
        return button
    }()
    private let summaryTextView: UITextView = {
        let view = UITextView()
        view.textContainerInset = .init(top: 20, left: 10, bottom: 100, right: 10)
        view.isScrollEnabled = false
        view.font = .nanumSquare(size: 14, family: .regular)
        return view
    }()
    private let bottomInfoTextView: UITextView = {
        let view = UITextView()
        view.textContainerInset = .init(top: 20, left: 10, bottom: 20, right: 10)
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        view.font = .nanumSquare(size: 10, family: .light)
        view.text = """
        [유의사항]
        ※내려받기의 경우 반드시 적립요청을 눌러 주세요.
        ※포인트 적립이 되지 않을 경우 리스트 상단의 문의하기에 남겨주세요.
        """
        return view
    }()
    
    // MARK: View lifecycle
    
    override func loadView() {
        super.loadView()
        setupLayoutConstraints()
        initView()
        setupActions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(with: detailViewModel)
        detailViewModel.onSuccessReturnParticipateURL = { info in
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: info.url)!)
            }
        }
        detailViewModel.onFailureReturnParticipateURL = { message in
            DispatchQueue.main.async {
                self.alert(message: message, cancelTitle: "확인")
            }
        }
    }
    
    // MARK: Main

    /// Initialize constraints
    private func setupLayoutConstraints() {
        let scrollView: UIScrollView = {
            let view = UIScrollView()
            view.backgroundColor = .RGB(240)
            return view
        }()
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fill
            stackView.backgroundColor = .white
            return stackView
        }()
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.left.right.equalToSuperview()
        }
        
        stackView.addArrangedSubview(feedImageView)
        feedImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.width.equalTo(feedImageView.snp.height).multipliedBy(2)
        }
        stackView.addArrangedSubview(feedInfoView)
        feedInfoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(100)
        }
        
        let buttonContainer = UIView()
        stackView.addArrangedSubview(buttonContainer)
        stackView.setCustomSpacing(10, after: buttonContainer)
        buttonContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        buttonContainer.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        scrollView.addSubview(summaryTextView)
        summaryTextView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        scrollView.addSubview(bottomInfoTextView)
        bottomInfoTextView.snp.makeConstraints { make in
            make.top.equalTo(summaryTextView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    /// Initialize properties
    private func initView() {
        configureCloseButton()
        view.backgroundColor = .white
    }
    
    /// Initialize actions
    private func setupActions() {
        button.addTarget(self, action: #selector(didTapParticipateInButton(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapParticipateInButton(_ sender: UIButton) {
        detailViewModel.participateIn()
    }
    
    private func setupUI(with vm: DetailViewModel) {
        title = "GreenP"
        guard let feed = vm.feed else { return }
        let imageURL = feed.imageURLStr.isEmpty ? feed.iconURLStr : feed.imageURLStr
        feedImageView.kf.setImage(with: URL(string: imageURL))
        feedInfoView.configure(title: feed.name, content: feed.subTitle, reward: feed.reward)
        button.setTitle("참여하고 리워드 받기", for: .normal)
        summaryTextView.text = feed.summary.replacingOccurrences(of: "\\n", with: "\n")
    }
}

class PaddingImageView: UIImageView {
    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    }
}
