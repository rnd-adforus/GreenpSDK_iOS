//
//  TrackingViewModel.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import Foundation
import AppTrackingTransparency
import AdSupport

enum TrackingPersmissionStatus: String {
    case authorized
    case denied
    case notDetermined
    case unknown
}

@available(iOS 14, *)

class TrackingViewModel {
    var trackingModelStatus: TrackingPersmissionStatus = .notDetermined
    var trackingManagerStatus: ATTrackingManager.AuthorizationStatus {
        return ATTrackingManager.trackingAuthorizationStatus
    }
    init() {
        updateCurrentStatus()
    }
    
    func updateCurrentStatus()  {
        let status = ATTrackingManager.trackingAuthorizationStatus
        switch status {
        case .authorized:
            trackingModelStatus = .authorized
        case .denied:
            trackingModelStatus = .denied
        case .notDetermined:
            trackingModelStatus = .notDetermined
        case .restricted:
            trackingModelStatus = .denied
        @unknown default:
            trackingModelStatus = .unknown
        }
    }

    func shouldShowAppTrackingDialog() -> Bool {
        let status = ATTrackingManager.trackingAuthorizationStatus
        guard status != .notDetermined else {
            return true
        }
        return false
    }
    
    func isAuthorized() -> Bool {
        return trackingManagerStatus == .authorized
    }
    
    func requestPermission() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("Authorized")
            case .denied:
                print("Denied")
            case .notDetermined:
                print("Not Determined")
            case .restricted:
                print("Restricted")
            @unknown default:
                print("Unknown")
            }
        }
    }
    
    func getIDFA() -> UUID {
        return ASIdentifierManager.shared().advertisingIdentifier
    }
    
    func getIDFAStr() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    func requestAppTrackingPermission(_ completion: @escaping (ATTrackingManager.AuthorizationStatus) -> Void) {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: completion)
    }
}
