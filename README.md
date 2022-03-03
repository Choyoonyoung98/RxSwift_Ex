# RxSwift_Ex
RxSwift 기반의 프로젝트 학습

### 1) NSObject + RxSwift
https://github.com/RxSwiftCommunity/NSObject-Rx

- 일반적으로 리소스 정리를 위해 사용하는 `disposeBag`. 하지만 클래스마다 처리해줘야 한다는 점이 번거롭다.  
-> RxSwift 라이브러리 사용 시, NSObject를 상속한 모든 클래스의 disposeBag의 속성이 추가
