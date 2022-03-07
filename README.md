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
  - ViewModel에는 크게 2가지 요소 포함
  1) 의존성을 주입하는 Intialize
  2) 바인딩에 사용되는 속성과 메서드 
- RxSwift에서는 Observable과 tableView를 바인딩하는 방식으로 데이터를 표시하기 때문에, dataSource를 통한 구현이 필요 없다.
- 앱을 구성하는 요소 사이의 의존성이 느슨

앱을 실행하면,
1) `MemoStorage`와 `SceneCoordinator`가 생성
2) ViewModel은 위 2개의 인스턴스를 통해 메모(데이터)를 저장하고, 화면을 처리한다.
3) 새로운 Scene을 생성하고, 연관값으로 ViewModel을 저장
4) coordinator에서 transition 메서드 호출 후, 파라미터로 scene 전달

- Cocoa에서는 segue가 화면 이동을 처리, MVVM에서는 ViewModel이 처리

> 생각해볼만한 문제: tap과 action을 통한 구현의 장단점 생각해보기

- [Advanced iOS App Architecture](https://store.raywenderlich.com/products/advanced-ios-app-architecture)
- [Clean Architecture and MVVM on iOS](https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3)
- [RxCoreData](https://github.com/RxSwiftCommunity/RxCoreData)
- [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources)

### 3) RxWeather
https://github.com/KxCoding/RxWeather
