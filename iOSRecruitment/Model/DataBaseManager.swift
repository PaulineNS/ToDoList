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
    
    func fetchTasksDependingList(list: List) -> [TaskList] {
        let request: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        let predicate = NSPredicate(format: "owner == %@", list)
        request.predicate = predicate
        guard let lists = try? managedObjectContext.fetch(request) else { return [] }
        return lists
    }
    
    var lists: [List] {
        let request: NSFetchRequest<List> = List.fetchRequest()
        guard let lists = try? managedObjectContext.fetch(request) else { return [] }
        return lists
    }
    
//    var tasks: [TaskList] {
//        let request: NSFetchRequest<TaskList> = TaskList.fetchRequest()
//        guard let tasks = try? managedObjectContext.fetch(request) else { return [] }
//        return tasks
//    }
    
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
    
    func createTask(name: String, list: List, note: String) {
        let task = TaskList(context: managedObjectContext)
        task.name = name
        task.note = note
        task.owner = list
        dataBaseStack.saveContext()
    }

//    func deleteAllTasks() {
//        lists.forEach { managedObjectContext.delete($0) }
//        dataBaseStack.saveContext()
//    }
}
