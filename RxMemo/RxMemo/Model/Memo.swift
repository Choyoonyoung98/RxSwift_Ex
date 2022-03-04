//
//  Memo.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import Foundation

//메모 구조체 선언
struct Memo: Equatable {
    var content: String //메모
    var insertDate: Date //생성날짜
    var identity: String //메모를 구분하기 위한 id
    
    //생성자 선언
    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    //생성자 하나 더 추가
    init(original: Memo, updatedContent: String) {
        self = original
        self.content = updatedContent
    }
}
