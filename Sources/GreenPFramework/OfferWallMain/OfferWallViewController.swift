//
//  OfferWallViewController.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit
import SnapKit
import Kingfisher
import UAdFramework

class OfferWallViewController : BaseViewController {
    private var childs: [FeedListViewController] = UserInfo.shared.tabs.enumerated().map{ FeedListViewController(index: $0.offset) }
    private var currentIndex: Int = 0
    private let offerWallViewModel = OfferWallViewModel()

    var countDownSeconds = 1
    var popupView: UIView!
    var countDownLabel: UILabel!
    var blurredView: UIVisualEffectView!

    private var splashBannerView: UAdBannerView!
    private var uAdBannerView: UAdBannerView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Never Will Happen")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        splashBannerView = AdsGlobal.shared.splashBannerView
        
        let uAdBanner = UAdBanner(zoneId: "JTBrvxfhpzmsoH9KuxLOCm2kGWA0", rootViewController: self, delegate: self)
        uAdBannerView = uAdBanner.getView()
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
        
        if (shouldShowPopup() && AdsGlobal.shared.isSplashLoaded) {
            setupPopupView()
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
        }
        
        if(uAdBannerView != nil) {
            uAdBannerView.load()
        }
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
    
    private func setupPopupView() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurredView = UIVisualEffectView(effect: blurEffect)
        blurredView.frame = view.bounds
        view.addSubview(blurredView)
        
        popupView = UIView()
        popupView.backgroundColor = UIColor.lightGray
        
        view.addSubview(popupView)
        popupView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(280)
            make.center.equalToSuperview()
        }

        popupView.addSubview(splashBannerView)
        
        splashBannerView.snp.makeConstraints { make in
            make.left.equalTo(popupView.snp.left)
            make.top.equalTo(popupView.snp.top)
        }
        
        countDownLabel = UILabel()
        countDownLabel.textAlignment = .center
        countDownLabel.textColor = UIColor.black
        countDownLabel.backgroundColor = .white
        countDownLabel.font = UIFont.systemFont(ofSize: 14)
        
        popupView.addSubview(countDownLabel)
        countDownLabel.snp.makeConstraints { make in
            make.bottom.equalTo(popupView.snp.bottom)
            make.height.equalTo(30)
            make.left.right.bottom.equalToSuperview()
        }
        
        countDownLabel.text = "2초 후 자동으로 종료됩니다."
    }
    
    func shouldShowPopup() -> Bool {
        if let savedDate = UserDefaults.standard.object(forKey: "popupShownDate") as? Date {
            let today = Calendar.current.startOfDay(for: Date())
            let savedDay = Calendar.current.startOfDay(for: savedDate)
            return today != savedDay
        }
        return true
    }

    func savePopupShownDate() {
        UserDefaults.standard.set(Date(), forKey: "popupShownDate")
    }
    
    @objc func updateCountDown() {
        countDownLabel.text = "\(countDownSeconds)초 후 자동으로 종료됩니다."
        countDownSeconds -= 1

        if countDownSeconds < 0 {
            popupView.removeFromSuperview()
            blurredView.removeFromSuperview()
            
            savePopupShownDate()
        }
    }
    
    @objc private func didTapMyPageButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            let vc = MypageViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func didTapSupportButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            let vc = CsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
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

extension OfferWallViewController: UAdFullScreenDelegate {
    func onFullScreenLoaded() {
    }
    
    func onFullScreenClicked() {
    }
    
    func onFullScreenShow() {
    }
    
    func onFullScreenDismiss() {
    }
    
    func onFullScreenFailed(msg: String) {
    }
}

extension OfferWallViewController: UAdBannerViewDelegate {
    func onBannerLoaded() {
        
        view.addSubview(uAdBannerView!)
        uAdBannerView!.translatesAutoresizingMaskIntoConstraints = false
        uAdBannerView!.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            make.centerX.equalTo(view)
        }
    }
    
    func onBannerClicked() {
    }
    
    func onBannerFailed(msg: String) {
    }
}
