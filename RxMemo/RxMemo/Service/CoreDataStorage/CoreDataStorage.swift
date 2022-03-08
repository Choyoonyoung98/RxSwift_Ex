//
//  CoreDataStorage.swift
//  RxMemo
//
//  Created by 조윤영 on 2022/03/08.
//

import Foundation
import RxSwift
import RxCoreData
import CoreData

class CoreDataStorage: MemoStorageType {
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]> {
        return mainContext.rx.entities(Memo.self, sortDescriptors: [NSSortDescriptor(key: "insertDate", ascending: false)])
            .map { results in [MemoSectionModel(model: 0, items: results)]}
    }
    
    @discardableResult
    func createMemo(content: String) -> Observable<Memo> {
        let memo = Memo(content: content)
        
        do {
            _ = try mainContext.rx.update(memo) //새로운 데이터 추가
            return Observable.just(memo)
        } catch {
            return Observable.error(error)
        }
    }
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo> {
        //memo.content = content 메모가 구조체로 선언되어 있고, 상수는 기본적으로 상수이기 때문에 이런 형태는 사용 불가
        
        let updated = Memo(original: memo, updatedContent: content)
        
        do {
            _ = try mainContext.rx.update(updated)
            return Observable.just(updated)
        } catch {
            return Observable.error(error)
        }
    }
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo> {
        do {
            try mainContext.rx.delete(memo)
            return Observable.just(memo)
        } catch {
            return Observable.error(error)
        }
    }
}
