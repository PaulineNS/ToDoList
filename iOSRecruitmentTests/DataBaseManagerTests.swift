//
//  DataBaseManagerTests.swift
//  iOSRecruitmentTests
//
//  Created by Pauline Nomballais on 22/02/2020.
//  Copyright © 2020 cheerz. All rights reserved.
//

@testable import iOSRecruitment
import XCTest

final class DataBaseManagerTests: XCTestCase {
    
    // MARK: - Variables
    
    var dataBaseStack: MockDataBaseStack!
    var dataBaseManager: DataBaseManager!
    
    // MARK: - Tests Life Cycle
    
    override func setUp() {
        super.setUp()
        dataBaseStack = MockDataBaseStack()
        dataBaseManager = DataBaseManager(dataBaseStack: dataBaseStack)
    }
    
    override func tearDown() {
        super.tearDown()
        dataBaseManager = nil
        dataBaseStack = nil
    }
    
    // MARK: - Tests
    
    func testCreateNewList_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        dataBaseManager.createList(name: "Courses")
        XCTAssertTrue(!dataBaseManager.lists.isEmpty)
        XCTAssertTrue(dataBaseManager.lists.count == 1)
        XCTAssertTrue(dataBaseManager.lists[0].name! == "Courses")
    }
    
    func testCreateNewTask_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        dataBaseManager.createList(name: "Courses")
        dataBaseManager.createTask(name: "Acheter pommes", list: dataBaseManager.lists[0], note: "1kg", deadLine: "10-05-2020")
        XCTAssertTrue(!dataBaseManager.fetchTasksDependingList(list: dataBaseManager.lists[0]).isEmpty)
        XCTAssertTrue(dataBaseManager.fetchTasksDependingList(list: dataBaseManager.lists[0]).count == 1)
        XCTAssertTrue(dataBaseManager.fetchTasksDependingList(list: dataBaseManager.lists[0])[0].name! == "Acheter pommes")
    }
    
    func testDeleteAllListsMethod_WhenEntitiesAreDeleted_ThenShouldBeCorrectlyDeleted() {
        dataBaseManager.createList(name: "Courses")
        dataBaseManager.deleteAllLists()
        XCTAssertTrue(dataBaseManager.lists.isEmpty)
    }
    
    func testDeleteAllTasksMethod_WhenEntitiesAreDeleted_ThenShouldBeCorrectlyDeleted() {
        dataBaseManager.createList(name: "Courses")
        dataBaseManager.createTask(name: "Acheter pommes", list: dataBaseManager.lists[0], note: "1kg", deadLine: "10-05-2020")
        dataBaseManager.deleteAllTasks(list: dataBaseManager.lists[0])
        XCTAssertTrue(dataBaseManager.fetchTasksDependingList(list: dataBaseManager.lists[0]).isEmpty)
    }
    
        func testDeleteOneListMethod_WhenEntityIsDeleted_ThenShouldBeCorrectlyDeleted() {
            dataBaseManager.createList(name: "Courses")
            dataBaseManager.createList(name: "Préparer vacances")
            dataBaseManager.deleteASpecificList(listName: "Courses")
        XCTAssertTrue(!dataBaseManager.lists.isEmpty)
        XCTAssertTrue(dataBaseManager.lists.count == 1)
        XCTAssertTrue(dataBaseManager.lists[0].name! == "Préparer vacances")
    }
    
    
    func testDeleteOneTaskMethod_WhenEntityIsDeleted_ThenShouldBeCorrectlyDeleted() {
            dataBaseManager.createList(name: "Courses")
        dataBaseManager.createTask(name: "Acheter pommes", list: dataBaseManager.lists[0], note: "1kg", deadLine: "10-05-2020")
        dataBaseManager.createTask(name: "Acheter kiwi", list: dataBaseManager.lists[0], note: "quantité : 8", deadLine: "10-05-2020")
        dataBaseManager.deleteASpecificTask(taskName: "Acheter pommes", list: dataBaseManager.lists[0])

        XCTAssertTrue(!dataBaseManager.fetchTasksDependingList(list: dataBaseManager.lists[0]).isEmpty)
        XCTAssertTrue(dataBaseManager.fetchTasksDependingList(list: dataBaseManager.lists[0]).count == 1)
        XCTAssertTrue(dataBaseManager.fetchTasksDependingList(list: dataBaseManager.lists[0])[0].name! == "Acheter kiwi")
    }
    
    func testCheckingListExistence_WhenFuncIsCalling_ThenShouldReturnTrue() {
        dataBaseManager.createList(name: "Courses")
        XCTAssertTrue(dataBaseManager.checkListExistence(listName: "Courses"))
       }
    
    func testCheckingTaskExistence_WhenFuncIsCalling_ThenShouldReturnTrue() {
        dataBaseManager.createList(name: "Courses")
        dataBaseManager.createTask(name: "Acheter pommes", list: dataBaseManager.lists[0], note: "1kg", deadLine: "10-05-2020")
        XCTAssertTrue(dataBaseManager.checkTaskExistenceInList(taskName: "Acheter pommes", list: dataBaseManager.lists[0]))
       }
    
    func testUpdateTaskStatus_WhenAnEntityIsUpdated_ThenShouldBeCorrectlySaved() {
        dataBaseManager.createList(name: "Courses")
        dataBaseManager.createTask(name: "Acheter pommes", list: dataBaseManager.lists[0], note: "1kg", deadLine: "10-05-2020")
        dataBaseManager.updateTaskStatus(taskName: "Acheter pommes", list: dataBaseManager.lists[0], status: true, forKey: "isDone")
        XCTAssertTrue(dataBaseManager.fetchTasksDependingList(list: dataBaseManager.lists[0])[0].isDone == true)

        


    }
    
}

