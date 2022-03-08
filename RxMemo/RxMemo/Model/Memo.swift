//
//  Memo.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/04.
//

import Foundation
import RxDataSources //TableView와 CollectionView에 바인딩할 수 있는 datasource 제공
import CoreData
import RxCoreData

//메모 구조체 선언
struct Memo: Equatable, IdentifiableType {
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

extension Memo: Persistable {
    static var entityName: String {
        return "Memo"
    }
    
    static var primaryAttributeName: String {
        return "identity"
    }
    
    init(entity: NSManagedObject) {
        content = entity.value(forKey: "content") as! String
        insertDate = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(content, forKey: "content")
        entity.setValue(insertDate, forKey: "insertDate")
        entity.setValue("\(insertDate.timeIntervalSinceReferenceDate)", forKey: "identity")
        
        do {
            try entity.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
}
