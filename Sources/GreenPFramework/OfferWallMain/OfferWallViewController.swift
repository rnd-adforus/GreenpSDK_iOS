//
//  OfferWallViewController.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit
import SnapKit

class OfferWallViewController : BaseViewController {
    private var childs: [FeedListViewController] = UserInfo.shared.tabs.enumerated().map{ FeedListViewController(index: $0.offset) }
    private var currentIndex: Int = 0
    private let offerWallViewModel = OfferWallViewModel()

    // MARK: Object lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Never Will Happen")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var pageControl = PageControlView(delegate: self)
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        addChild(vc)
        return vc
    }()
    private var footer: FooterView = FooterView()
    
    // MARK: Setup UI properties

    private let naviTitleView = NavigationTitleView()
    private lazy var myPageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        button.tintColor = .white
        return button
    }()
    private lazy var supportButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        button.tintColor = .white
        return button
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
        self.childs.first?.feedListViewModel.load()
    }
    
    // MARK: Main

    /// Initialize constraints
    private func setupLayoutConstraints() {
        supportButton.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        myPageButton.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(footer)
        footer.snp.makeConstraints { make in
            make.height.equalTo(BOTTOM_BAR_HEIGHT + 10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    /// Initialize properties
    private func initView() {
        configureNavigationBar()
        view.backgroundColor = UserInfo.shared.themeColor
        pageViewController.setViewControllers([childs.first!], direction: .forward, animated: false, completion: nil)
    }
    
    /// Initialize actions
    private func setupActions() {
        myPageButton.addTarget(self, action: #selector(didTapMyPageButton(_:)), for: .touchUpInside)
        supportButton.addTarget(self, action: #selector(didTapSupportButton(_:)), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapFooterView(_:)))
        footer.addGestureRecognizer(tap)
    }
     
    private func configureNavigationBar() {
        closeButton.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: naviTitleView)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: closeButton),
            UIBarButtonItem(customView: supportButton),
            UIBarButtonItem(customView: myPageButton)
        ]
    }
    
    @objc private func didTapMyPageButton(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: MYPAGE_URL_ADDRESS)!)
    }
    
    @objc private func didTapSupportButton(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: SUPPORT_URL_ADDRESS)!)
    }
    
    @objc private func didTapFooterView(_ sender: UITapGestureRecognizer) {
        let vc = WebViewController(url: PRIVACY_POLICY_URL_ADDRESS)
        let navi = NavigationController(rootViewController: vc)
        present(navi, animated: true)
    }
    
}

extension OfferWallViewController : PageControlViewDelegate {
    func didTapPageControlAt(index: Int) {
        pageViewController.setViewControllers([childs[index]], direction: .forward, animated: false, completion: {_ in
            self.childs[index].feedListViewModel.load()
        })
    }
}
