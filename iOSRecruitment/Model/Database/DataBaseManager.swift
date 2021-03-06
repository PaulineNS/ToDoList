//
//  DataBaseManager.swift
//  iOSRecruitment
//
//  Created by Pauline Nomballais on 21/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

import Foundation
import CoreData

open class DataBaseManager {
    
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
    
    func fetchImportantsTasks() -> [TaskList] {
        let request: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        let predicate = NSPredicate(format: "isImportant == 1")
        request.predicate = predicate
        guard let tasks = try? managedObjectContext.fetch(request) else { return [] }
        return tasks
    }
    
    var lists: [List] {
        let request: NSFetchRequest<List> = List.fetchRequest()
        guard let lists = try? managedObjectContext.fetch(request) else { return [] }
        return lists
    }
    
    var tasks: [TaskList] {
        let request: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        guard let tasks = try? managedObjectContext.fetch(request) else { return [] }
        return tasks
    }
    
    // MARK: - Initializer
    
    init(dataBaseStack: DataBaseStack) {
        self.dataBaseStack = dataBaseStack
        self.managedObjectContext = dataBaseStack.mainContext
    }
    
    // MARK: - Create Entity
    
    ///Create a list entity
    func createList(name: String) {
        let list = List(context: managedObjectContext)
        list.name = name
        dataBaseStack.saveContext()
    }
    
    ///Create a task entity
    func createTask(name: String, list: List, note: String, deadLine: String) {
        let task = TaskList(context: managedObjectContext)
        task.isDone = false
        task.isImportant = false
        task.deadline = deadLine
        task.name = name
        task.note = note
        task.owner = list
        dataBaseStack.saveContext()
    }
    
    // MARK: - Update Entity
    
    /// Update isDone and isImportant status
    func updateTaskStatus(taskName: String, list: List, status: Bool, forKey: String) {
        let request: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        let predicateOwner = NSPredicate(format: "owner == %@", list)
        let predicateTaskName = NSPredicate(format: "name == %@", taskName)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOwner, predicateTaskName])
        request.predicate = andPredicate
        guard let tasks = try? managedObjectContext.fetch(request) else { return }
        if tasks.count != 0 {
            let managedObject = tasks[0]
            managedObject.setValue(status, forKey: forKey)
            dataBaseStack.saveContext()
        }
    }
    
    // MARK: - Delete Entity
    
    ///Delete all tasks entitites
    private func deleteAllTasks() {
        tasks.forEach { managedObjectContext.delete($0) }
        dataBaseStack.saveContext()
    }
    
    /// Delete all tasks in a specific list
    func deleteAllTasks(list: List) {
        fetchTasksDependingList(list: list).forEach { managedObjectContext.delete($0) }
        dataBaseStack.saveContext()
    }
    
    /// Delete all lists and tasks
    func deleteAllLists() {
        deleteAllTasks()
        lists.forEach { managedObjectContext.delete($0) }
        dataBaseStack.saveContext()
    }
    
    ///Delete a specific list according his name
    func deleteASpecificList(listName: String) {
        let request: NSFetchRequest<List> = List.fetchRequest()
        let predicateListName = NSPredicate(format: "name == %@", listName)
        request.predicate = predicateListName
        
        if let objects = try? managedObjectContext.fetch(request) {
            objects.forEach { managedObjectContext.delete($0)}
        }
        dataBaseStack.saveContext()
    }
    
    /// Delete a specific task according his name and list owner
    func deleteASpecificTask(taskName: String, list: List) {
        let request: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        let predicateOwner = NSPredicate(format: "owner == %@", list)
        let predicateTaskName = NSPredicate(format: "name == %@", taskName)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOwner, predicateTaskName])
        request.predicate = andPredicate
        if let objects = try? managedObjectContext.fetch(request) {
            objects.forEach { managedObjectContext.delete($0)}
        }
        dataBaseStack.saveContext()
    }
    
    // MARK: - Check Entity existence
    
    /// check if a list exist in the dataBase thanks to his name
    func checkListExistence(listName: String) -> Bool {
        let request: NSFetchRequest<List> = List.fetchRequest()
        let predicateListName = NSPredicate(format: "name == %@", listName)
        request.predicate = predicateListName
        
        guard let lists = try? managedObjectContext.fetch(request) else { return false }
        if lists.isEmpty {return false}
        return true
    }
    
    /// check if a task exist in the dataBase thanks to his name and list owner
    func checkTaskExistenceInList(taskName: String, list: List) -> Bool {
        let request: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        let predicateOwner = NSPredicate(format: "owner == %@", list)
        let predicateTaskName = NSPredicate(format: "name == %@", taskName)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateOwner, predicateTaskName])
        request.predicate = andPredicate
        guard let tasks = try? managedObjectContext.fetch(request) else { return false }
        if tasks.isEmpty {return false}
        return true
    }
}
