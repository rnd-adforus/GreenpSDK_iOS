//
//  AdsGlobal.swift
//
//
//  Created by 신아람 on 1/24/24.
//

import UIKit
import UAdFramework

class AdsGlobal {
    
    var isSplashLoaded = false
    var splashBannerView: UAdBannerView!
    
    var MAX_NATIVE_AD = 3
    var isNativeLoaded = false
    var nativeLoders: [UAdAdLoader] = []
    var nativeAds: [UAdNativeAd] = []
    var exposureCnt: [Int] = []
    
    var onResultInitialize: ((_ result: Bool) -> Void)?
    
    static let shared: AdsGlobal = {
        let instance = AdsGlobal()
        return instance
    }()
    
    init() {
    }
    
    func makeGlobalViews() {
        
        var vc = UIApplication.getMostTopViewController()!
        
        DispatchQueue.main.async {
            let uAdBanner = UAdBanner(zoneId: "Z3B3hGaduFyoNLlxWn8k8fUJXAPF", rootViewController: vc, delegate: self)
            uAdBanner.setSize(size: UAdBannerSize.BANNER300X250)
            self.splashBannerView = uAdBanner.getView()
            self.splashBannerView.load()
            
        }
        
        DispatchQueue.global().async { [self] in
            for _ in 0..<MAX_NATIVE_AD {
                let uAdAdLoader = UAdAdLoader(zoneId: "teirUpF0uHvCCIIi9vlbktdQpAwT", rootViewController: vc, delegate: self)
                nativeLoders.append(uAdAdLoader)
                uAdAdLoader.load()
            }
        }
    }
}

extension AdsGlobal: UAdBannerViewDelegate {
    func onBannerLoaded() {
        print("bannerViewDidReceiveAd")
        isSplashLoaded = true
    }
    
    func onBannerClicked() {
    }
    
    func onBannerFailed(msg: String) {
    }
}

extension AdsGlobal: UAdNativeAdLoaderDelegate {
    func onNativeLoaderLoaded(nativeAd: UAdFramework.UAdNativeAd) {
        isNativeLoaded = true
        nativeAds.append(nativeAd)
        exposureCnt.append(0)
    }
    
    func onNativeLoaderFailed(msg: String) {
    }
}

extension AdsGlobal: UAdNativeAdDelegate {
    func onNativeAdLoaded() {
    }
    func onNativeAdClicked() {
    }
    func onNativeAdShow() {
    }
    func onNativeAdDismiss() {
    }
    func onNativeAdFailed(msg: String) {
    }
}
