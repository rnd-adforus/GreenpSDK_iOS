## GreenPFramework

## Version 1.0.5
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
