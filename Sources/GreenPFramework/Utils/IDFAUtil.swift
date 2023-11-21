//
//  IDFAUtil.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import Foundation
import AdSupport
import AppTrackingTransparency

class IDFAUtil {
    
    @available(iOS 14, *)
    class var status: ATTrackingManager.AuthorizationStatus {
            return  ATTrackingManager.trackingAuthorizationStatus
    }
    
    @available(iOS 14, *)
    class func requestPermission() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                // Tracking authorization dialog was shown
                // and we are authorized
                print("Authorized")
            
                // Now that we are authorized we can get the IDFA
            print(ASIdentifierManager.shared().advertisingIdentifier)
            case .denied:
               // Tracking authorization dialog was
               // shown and permission is denied
                 print("Denied")
            case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
            case .restricted:
                    print("Restricted")
            @unknown default:
                    print("Unknown")
            }
        }
    }
}

