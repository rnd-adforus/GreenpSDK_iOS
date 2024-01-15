//
//  File.swift
//  
//
//  Created by adforus_m1 on 1/12/24.
//

import Foundation
import Flutter

protocol ResultSending : AnyObject {
    func sendResult(message: String)
}

enum FlutterResultType {
    case success
    case error
}

public class GreenpFlutter {
    private var baseChannel = "com.adforus.sdk/greenp_channel"
    private var methodChannel: FlutterMethodChannel?
    private var engine: FlutterEngine?
    private var controller: UIViewController?
    private var greenp : GreenPSettings?
    private var isInitGreenp = false
    public var flutterResult : FlutterResult?

    public init(flutterEngine : FlutterEngine){
        engine = flutterEngine
        initHandle()
    }
    
    private func initHandle(){
        if methodChannel == nil {
            if let binaryMsg = engine?.binaryMessenger {
                methodChannel = FlutterMethodChannel(name: baseChannel, binaryMessenger: binaryMsg)
            }
        }
        methodChannel?.setMethodCallHandler({
            [weak self] (methodCall : FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            self?.flutterResult = result;
            switch methodCall.method {
                case "initOfferWall" :
                    
                    let delegateObject: GreenPDelegate = {
                        class AnyObject : GreenPDelegate {
                            weak var parent: GreenpFlutter?

                            init(parent: GreenpFlutter) {
                                self.parent = parent
                            }
                            func greenPSettingsDidEnd(with message: String) {
                                if let greenpFlutter = self.parent {
                                    greenpFlutter.sendResult(type: FlutterResultType.success , msg: message)
                                }
                            }
                        }
                        return AnyObject(parent: self!)
                    }()

                    self?.greenp = GreenPSettings(delegate: delegateObject)
                    
                    if let arguments = methodCall.arguments as? [String: Any],
                    let appCode = arguments["appCode"] as? String{
                        self?.greenp?.set(appCode: appCode, userID: arguments["userId"] as? String ?? "")
                    }else {
                        self?.sendResult(type: FlutterResultType.error, msg: "invalid appCode")
                    }
                   
                    break;
                case "startOfferWallActivity":
                    if let flutterViewController = self?.controller {
                        self!.greenp?.show(on: flutterViewController)
                        self!.sendResult(type: FlutterResultType.success, msg: "greenp offerwall show")
                    }
                    break;
                default:
                    self?.sendResult(type: FlutterResultType.error, msg: "invalid methodCall")
            }
        })
    }
    
    public func setController(_ controller: UIViewController){
        self.controller = controller
    }
    
    private func sendResult(type : FlutterResultType, msg : String){
        switch type {
        case .success :
            flutterResult?(msg)
        case .error :
            let error = FlutterError(
                code: "", message: msg, details: ""
            )
            flutterResult?(error)
        }
    }

}
