//
//  DataManager.swift
//  FitTimer
//
//  Created by 이상도 on 2023/03/20.
//

import Foundation
import CoreData

class DataManager {
    
    // Singleton
    static let shared = DataManager()
    private init() {
        
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // DB에서 Memo 읽어 오는 코드
    var memoList = [Memo]()
    
    func fetchMemo() { // fetch : 읽어오다
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        // 날짜 내림차순
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        do {
            memoList = try mainContext.fetch(request) // 정렬후 배열에 저장
        } catch {
            print(error)
        }
    }
    
    
    func addNewMemo(_ memo: String?) {
        let newMemo = Memo(context: mainContext)
        newMemo.content = memo
        newMemo.insertDate = Date()
        
        memoList.insert(newMemo, at: 0)
        
        saveContext()
    }
    
    // Memo 삭제 메소드
    func deleteMemo(_ memo: Memo?) {
        if let memo = memo{
            mainContext.delete(memo)
            saveContext()
        }
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "FitTimer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
