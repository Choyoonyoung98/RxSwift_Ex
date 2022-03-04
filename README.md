# RxSwift_Ex
RxSwift 기반의 프로젝트 학습

### 1) NSObject + RxSwift
https://github.com/RxSwiftCommunity/NSObject-Rx

- 일반적으로 리소스 정리를 위해 사용하는 `disposeBag`. 하지만 클래스마다 처리해줘야 한다는 점이 번거롭다.  
-> RxSwift 라이브러리 사용 시, NSObject를 상속한 모든 클래스의 disposeBag의 속성이 추가

### 2) RxMemo
- `RxSwift`,`RxCocoa`,`RxCoreData`,`RxDatasources`,`NSObject+RxSwift` 라이브러리 의존 
- MVVM Architecture
  - 화면 전환: ViewModel과 Scene cordinator가 진행
  - 나머지 부분: MVVM(Model, ViewController, ViewModel)
- [Advanced iOS App Architecture](https://store.raywenderlich.com/products/advanced-ios-app-architecture)
- [Clean Architecture and MVVM on iOS](https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3)
- [RxCoreData](https://github.com/RxSwiftCommunity/RxCoreData)
- [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources)
