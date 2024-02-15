//
//  FeedListTableViewAdCell.swift
//
//
//  Created by 신아람 on 1/19/24.
//

import UIKit
import SnapKit
import Kingfisher
import UAdFramework
import GADNativeAdTemplate

extension FeedListTableViewAdCell {
    func configure(_ data: UAdNativeAd) {
        
        print("configure")
        nativeAd = data
        
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline()
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction(), for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction() == nil
        
        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store()
        nativeAdView.storeView?.isHidden = nativeAd.store() == nil
        
        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser()
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser() == nil
        
        nativeAdView.nativeAd = nativeAd.getNativeAd()    }
}

class FeedListTableViewAdCell : UITableViewCell, TableViewCellReusable {
    
    var nativeAd: UAdNativeAd!
    var nativeAdView: UAdNativeAdView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Never Will Happen")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        var height = 90
        if(UserInfo.shared.settings.listType == .list) {
            let nibView = Bundle.module.loadNibNamed("UAdSmallTemplate", owner: nil, options: nil)?.first
            guard let nativeAdView = nibView as? UAdNativeAdView else {
                return
            }
            self.nativeAdView = nativeAdView
            
        } else {
            height = 290
            let nibView = Bundle.module.loadNibNamed("UAdMediumTemplate", owner: nil, options: nil)?.first
            guard let nativeAdView = nibView as? UAdNativeAdView else {
                return
            }
            self.nativeAdView = nativeAdView
        }
        
        let bgView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(5)
            make.height.equalTo(height)
        }
        bgView.addSubview(self.nativeAdView)
        self.nativeAdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(height)
        }
    }
}
