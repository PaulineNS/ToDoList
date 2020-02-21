//
//  DataBaseManager.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import Foundation
import CoreData

final class DataBaseManager {

    // MARK: - Variables
    
    private let dataBaseStack: DataBaseStack
    private let managedObjectContext: NSManagedObjectContext
    
    var lists: [List] {
        let request: NSFetchRequest<List> = List.fetchRequest()
        guard let lists = try? managedObjectContext.fetch(request) else { return [] }
        return lists
    }
    
    // MARK: - Initializer
    
    init(dataBaseStack: DataBaseStack) {
        self.dataBaseStack = dataBaseStack
        self.managedObjectContext = dataBaseStack.mainContext
    }
    
    // MARK: - Manage List Entity

    func createList(name: String) {
        let list = List(context: managedObjectContext)
        list.name = name
        dataBaseStack.saveContext()
    }

    func deleteAllTasks() {
        lists.forEach { managedObjectContext.delete($0) }
        dataBaseStack.saveContext()
    }
}
