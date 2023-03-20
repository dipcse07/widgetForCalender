//
//  Persistence.swift
//  widgetForCalender
//
//  Created by MD SAZID HASAN DIP on 2023/03/15.
//

import CoreData

struct PersistenceController {
    
    let databaseName = "widgetForCalender.sqlite"
    var shareStorageUrl: URL {
        
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent(databaseName)
    }
    
    var oldStoreUrl: URL {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.debuggerlab.widgetForCalender")!
        return container.appendingPathComponent(databaseName)
    }
    
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let startDate = Calendar.current.dateInterval(of: .month, for: .now)!.start
        for dayOffset in 0..<30 {
            let newDay = Day(context: viewContext)
            newDay.date = Calendar.current.date(byAdding: .day, value: dayOffset, to: startDate)
            newDay.didStudy = Bool.random()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "widgetForCalender")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }else if !FileManager.default.fileExists(atPath: oldStoreUrl.path){
            print("Old Store does not exit. Pointing to sharedStorageUrl")
            container.persistentStoreDescriptions.first!.url = shareStorageUrl
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        migrateStore(for: container)
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func migrateStore(for container: NSPersistentContainer){
        print("Migrate Store Started")
        let coordinator = container.persistentStoreCoordinator
        guard let oldStore = coordinator.persistentStore(for: oldStoreUrl) else {return}
        
        do {
            try _ = coordinator.migratePersistentStore(oldStore, to: shareStorageUrl, type: .sqlite)
            print("Migration Successfull")
        }catch {
            fatalError("Unable to migrate to shared store")
        }
        
        do {
            try FileManager.default.removeItem(at: oldStoreUrl)
            print("Old store deleted")
        }catch {
            print("Unable to delte oldStore")
        }
    }
}
