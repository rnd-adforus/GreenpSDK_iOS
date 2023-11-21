## GreenPFramework

## Version 1.0.0
- Swift version 5.0
- Minimum iOS version 14.0
  
## Installation
GreenPFramework support [Swift Package Manager](https://www.swift.org/package-manager/)
1. File -> Add Packages...
2. Find Package With Url - "https://github.com/rnd-adforus/GreenpSDK_iOS.git"

## Info.plist
광고 추적 권한<br>
<img width="1234" alt="스크린샷 2023-11-21 오후 9 05 22" src="https://github.com/rnd-adforus/GreenpSDK_iOS/assets/54663383/61ea8a3e-b931-4847-bffc-8c3c40c7b31b">
<br>http 통신 예외처리<br>
<img width="803" alt="스크린샷 2023-11-21 오후 9 08 45" src="https://github.com/rnd-adforus/GreenpSDK_iOS/assets/54663383/03677f73-5197-40c8-8cf3-91c68e7849ba">

## Initialize
```swift
import GreenPFramework

var builder: GreenPBuilder?

/// 오퍼월 초기화 및 사용자 등록
func initializeOW() {
    let greenP = GreenPSettings(appCode: /*앱 코드*/,
                        userID: /*유저 아이디*/,
                        completion: {  [weak self] (result, message, builder) in
      if result == true {
          // return builder
      }
  })
}

/// 화면에 오퍼월 충전소를 호출하는 함수.
/// 버튼을 누를 때 호출
builder?.show(on: self)

```
