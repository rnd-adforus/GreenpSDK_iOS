//
//  GreenPSettings.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import Foundation
import AdSupport
import MessageUI
import AppTrackingTransparency

let DEBUG_MARK = "OfferWall Message : "

public protocol GreenPDelegate : AnyObject {
    func greenPSettingsDidEnd(with message: String)
}

open class GreenPSettings {
    private var delegate: GreenPDelegate?
    
    public init(delegate: GreenPDelegate) {
        self.delegate = delegate
    }
    
    public func set(appCode: String, userID: String) {
        UserInfo.shared.appCode = appCode
        UserInfo.shared.userID = userID
        setIDFAAndRegistDevice()
    }

    private func setIDFAAndRegistDevice() {
        let vm = TrackingViewModel()
        let status = ATTrackingManager.trackingAuthorizationStatus
        UserInfo.shared.idfa = ""
        if status == .authorized {
            UserInfo.shared.idfa = vm.getIDFAStr()
            regist()
        } else if status == .denied || status == .restricted {
            showSettingsAlert()
        } else {
            ATTrackingManager.requestTrackingAuthorization { [weak self] status in
                if status == .authorized {
                    UserInfo.shared.idfa = vm.getIDFAStr()
                    self?.regist()
                } else {
                    self?.showSettingsAlert()
                }
            }
        }
    }
    
    private func showSettingsAlert() {
        UIApplication.getMostTopViewController()?.alert(message: "더 개인화된 광고 제공을 위해 IDFA 정보가 필요합니다. 설정에서 광고 추적 권한을 허용해 주세요.", title: "알림", confirmTitle: "설정으로 이동", confirmHandler: { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(settingsUrl)
                }
            }
        }, cancelTitle: "닫기", cancelHandler: { _ in
            self.delegate?.greenPSettingsDidEnd(with: "IDFA 권한 없음.")
        })
    }
    
    private func regist() {
        let param = DeviceRegistParam()
        Task {
            do {
                let result: APIResult = try await NetworkManager.shared.request(subURL: "sdk/device_regist.html", params: param.dictionary, method: .get)
                if result.result == "0" {
                    Task { @MainActor in
                        delegate?.greenPSettingsDidEnd(with: result.message)
                    }
                } else {
                    Task { @MainActor in
                        delegate?.greenPSettingsDidEnd(with: result.message)
                    }
                }
            } catch let error {
                Task { @MainActor in
                    delegate?.greenPSettingsDidEnd(with: error.localizedDescription)
                }
            }
        }
    }
    
    public func show(on viewController: UIViewController) {
        let status = ATTrackingManager.trackingAuthorizationStatus
        if status == .authorized {
            UIFont.registerAllFonts()
            let vc = SplashViewController()
            let navi = NavigationController(rootViewController: vc)
            navi.modalPresentationStyle = .automatic
            navi.isModalInPresentation = true
            viewController.present(navi, animated: true, completion: nil)
        }else{
            UserInfo.shared.idfa = ""
            showSettingsAlert()
        }
        
    }
}
