## GreenPFramework

## Version 1.0.6
- Swift version 5.8
- Minimum iOS version 14.0
  
## Installation
GreenPFramework support [Swift Package Manager](https://www.swift.org/package-manager/)
1. File -> Add Packages...
2. Find Package With Url - "https://github.com/rnd-adforus/GreenpSDK_iOS.git"

## Info.plist
광고 추적 권한<br>
<img width="1234" alt="스크린샷 2023-11-21 오후 9 05 22" src="https://i.imgur.com/mSqChu7.png">
<br>http 통신 예외처리<br>
<img width="803" alt="스크린샷 2023-11-21 오후 9 08 45" src="https://i.imgur.com/W43n4Oc.pnga">

## Initialize
```swift
import GreenPFramework

private lazy var greenP = GreenPSettings(delegate: self)

/// 오퍼월 초기화 및 사용자 등록
greenP.set(appCode: "Your Code", userID: "user ID")

/// 화면에 오퍼월 충전소를 호출하는 함수.
/// 버튼을 누를 때 호출
greenP.show(on: self)


extension ViewController : GreenPDelegate {
    func greenPSettingsDidEnd(with message: String) {
      // 성공 & 실패 시 메세지 노출
    }
}

```
※ 유저 구분값 생성 규칙
1. 각각의 유저별 고유한 값을 이용해야 합니다.
2. 개인정보 및 IDFA는 사용할 수 없습니다. ( 암호화 후 사용 가능 )
3. 한글, 특수문자, 공백은 반드시 URL 인코딩 후 사용하셔야 합니다.

## Callback Parameter  
> 광고 참여가 정상적으로 완료된 경우, 매체사에서 등록 하신 콜백 URL로 암호화키를 전송해 드립니다.
> <pre><b>CallBack url : 매체사 URL</b></pre>
> <pre><b>Method : GET or POST (기본은 GET 방식이나 요청시 POST 방식으로도 가능합니다.</b></pre>
|Ad Parameter|Type|설명|
|----------------|-------------------------------|-----------------------------|
|ads_idx   |`int`    |광고키             |
|ads_name  |`string` |갬페인 타이틀        |
|rwd_cost  |`int`    |매체사에 지급되는 단가 |
|app_uid   |`string` |매체사에 보낸 유저 구분 값 (UserID) |
|gp_key    |`int`    |전환 건에 대한 유니크 값 |
|etc       |`int`    |referrer 값. 매체용 추가 정보(매체 uniq 클릭값 등) etc 대신 원하는 파라미터로 변경가능 |

## support for other platforms
1. [Flutter](https://github.com/rnd-adforus/GreenpSDK_iOS/wiki/Flutter-GreenpOfferwall-SDK-for-%08iOS)

