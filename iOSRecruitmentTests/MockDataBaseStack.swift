//
//  MockDataBaseStack.swift
//  iOSRecruitmentTests
//
//  Created by Pauline Nomballais on 22/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import Foundation
import iOSRecruitment
import CoreData

final class MockDataBaseStack: DataBaseStack {
    
    // MARK: - Initializer
    
    convenience init() {
        self.init(modelName: "ToDoList")
    }
    
    override init(modelName: String) {
        super.init(modelName: modelName)
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.persistentContainer = container
    }
    
}
