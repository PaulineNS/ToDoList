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
    
    var list: [List] {
        let request: NSFetchRequest<List> = List.fetchRequest()
        guard let recipes = try? managedObjectContext.fetch(request) else { return [] }
        return recipes
    }
    
//    var favoritesRecipes: [FavoritesRecipesList] {
//        let request: NSFetchRequest<FavoritesRecipesList> = FavoritesRecipesList.fetchRequest()
//        guard let recipes = try? managedObjectContext.fetch(request) else { return [] }
//        return recipes
//    }
    
    // MARK: - Initializer
    
    init(dataBaseStack: DataBaseStack) {
        self.dataBaseStack = dataBaseStack
        self.managedObjectContext = dataBaseStack.mainContext
    }
}
