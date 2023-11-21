//
//  SplashViewController.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/19.
//

import UIKit

class SplashViewController : BaseViewController {
    private let splashViewModel = SplashViewModel()
    
    // MARK: Object lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Never Will Happen")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: View lifecycle
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
            
        if UserInfo.shared.isPermitted {
            splashViewModel.fetchSettings()
        } else {
            showPrivacyPolicyAlert()
        }
        
        splashViewModel.onSuccessLoadTabData = {
            self.settingsDidLoad()
        }
    }
    
    private func showPrivacyPolicyAlert() {
        alert(message: "개인정보 수집 동의\n(주)애드포러스가 제공하는 리워드 오퍼월 서비스를 이용하기 위해서는 아래의 정보수집에 대한 동의가 필요합니다.\n수집된 정보는 광고 참여의 개인 식별을 위한 용도로만 활용되는 서비스 제공을 위한 필수 정보이며, 거부하실 경우 서비스를 이용하실 수 없습니다.", title: "개인정보 수집 동의", confirmTitle: "동의", confirmHandler: { _ in
            UserInfo.shared.isPermitted = true
            self.splashViewModel.fetchSettings()
        }, cancelTitle: "거부") { _ in
            self.dismiss(animated: true)
        }
    }
    
    private func settingsDidLoad() {
        DispatchQueue.main.async {
            let vc = OfferWallViewController()
            self.navigationController?.setViewControllers([vc], animated: false)
        }
    }
}
