//
//  GreenPSettings.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import Foundation
import AdSupport
import MessageUI

let DEBUG_MARK = "OfferWall Message : "

extension UIDevice {
    var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
}

public protocol GreenPDelegate : AnyObject {
    
}
open class GreenPSettings {
    private var delegate: GreenPDelegate?
    init(delegate: GreenPDelegate) {
        self.delegate = delegate
    }
    
    /// 그린피 초기화 함수.
    public init(appCode: String, userID: String, completion: @escaping (Bool, String?, GreenPBuilder?) -> Void) {
        
        UserInfo.shared.appCode = appCode
        UserInfo.shared.userID = userID
        
        setIDFAAndRegistDevice(completion: completion)
    }
    
    private func setIDFAAndRegistDevice(completion: @escaping (Bool, String?, GreenPBuilder?) -> Void) {
        let vm = TrackingViewModel()
        
        //처음 팝업을 표시하는 경우
        if vm.shouldShowAppTrackingDialog() {
            vm.requestAppTrackingPermission { [weak self] (status) in
                vm.updateCurrentStatus()
                
                if vm.isAuthorized() {
                    UserInfo.shared.idfa = vm.getIDFAStr()
                    self?.regist(completion: completion)
                }
            }
        } else {  //이미 팝업을 표시한 적이 있는 경우
            //권한을 받은 경우
            if vm.isAuthorized() {
                UserInfo.shared.idfa = vm.getIDFAStr()
                self.regist(completion: completion)
            }
            //유저가 권한을 주지 않은 경우
            else {
                completion(false, "\(DEBUG_MARK)need IDFA authorization.", nil)
            }
        }
    }
    
    private func validateDeviceRegistParam(param: DeviceRegistParam) -> Bool {
        if param.appCode.isEmpty || param.userID.isEmpty || param.idfa.isEmpty || param.uuid.isEmpty || param.model.isEmpty {
            return false
        }
        else {
            return true
        }
    }
    
    private func regist(completion: @escaping (Bool, String?, GreenPBuilder?) -> Void) {
        
        let param = DeviceRegistParam()
        
//        // 유저 인포 정보가 불충분한 경우
//        if UIDevice.current.isSimulator == false && validateDeviceRegistParam(param: param) == false {
//            completion(false, "UserInfo is incomplete", nil)
//        }
//
        Task {
            do {
                let result: APIResult = try await NetworkManager.shared.request(subURL: "sdk/device_regist.html", params: param.dictionary, method: .get)
                if result.result == "0" {
                    completion(true, result.message, GreenPBuilder())
                } else {
                    completion(false, result.message, nil)
                }
            } catch let error {
                completion(false, error.localizedDescription, nil)
            }
        }
    }
}
