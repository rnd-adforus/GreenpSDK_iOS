//
//  Constants.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit

let HOME_URL = "api.greenp.kr"

let FEED_PAGE_LIMIT: Int = 50

let PRIVACY_POLICY_URL_ADDRESS = "http://api.greenp.kr/sdk/privacy.html"
let SUPPORT_URL_ADDRESS = "http://api.greenp.kr/sdk/sdk_qna_webview.html"
let MYPAGE_URL_ADDRESS = "http://api.greenp.kr/sdk/sdk_mypage_webview.html"

let MESSAGE_SERVER_ERROR = "서버와의 연결이 원활하지 않습니다."
let MESSAGE_AD_DETAIL_URL_ERROR = "광고 URL이 잘못되었습니다."

/// 하단 바 높이
var BOTTOM_BAR_HEIGHT: CGFloat {
    return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
}
