//
//  CoreDataObjectManager.swift
//  Recipe Book
//
//  Created by Clarence Siew on 10/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class CoreDataObjectManager: ObservableObject {
    var appDelegate: AppDelegate
    var managedObjectContext: NSManagedObjectContext
    var persistentContainer: NSPersistentContainer
    var recipes: [Recipe] = Array<Recipe>()
    var selectedRecipe: Recipe? = nil
    
    init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.appDelegate = appDelegate!
        self.persistentContainer = (appDelegate?.persistentContainer)!
        self.managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
    }
    
    func loadData() {
        self.fetchRecipes()
    }
    
    func save() {
        if self.managedObjectContext.hasChanges == true {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Unable to save: \(error), \(error.userInfo)")
            }
            
            self.loadData()
        }
    }
    
    func addRecipe(id: String? = nil, name: String? = "", description: String? = "", source: String? = "", ingredients: Set<Ingredient>? = Set<Ingredient>(), directions: [String]? = Array()) -> Recipe {
        let recipe = NSEntityDescription.insertNewObject(forEntityName: "Recipe", into: managedObjectContext) as! Recipe
        recipe.id = id ?? UUID().uuidString
        recipe.name = name!
        recipe.recipeDescription = description!
        recipe.source = source!
        recipe.ingredients = ingredients!
        recipe.directions = directions!
        
        self.save()
        
        return recipe
    }
    
    func fetchRecipes() {
        var results = [Recipe]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        request.returnsObjectsAsFaults = false
        
        // Fetch reports from Core Data
        do {
            results = try managedObjectContext.fetch(request) as! [Recipe]
        } catch {
            print("Failed to fetch recipes: \(error)")
        }
        
        self.recipes = results
    }
    
    func selectRecipe(id: String) {
        let results = recipes.filter({ $0.id == id })
        if results.count >= 1 {
            self.selectedRecipe = results.first
        }
    }
    
    func deselectRecipe() {
        self.selectedRecipe = nil
    }
    
    func fetchRecipeById(id: String) -> [Recipe] {
        let results = self.recipes.filter { $0.id == id }
        return results
    }
    
    func updateRecipe(recipe: Recipe) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")

        fetchRequest.predicate = NSPredicate(format: "id = %@", argumentArray: [recipe.id])

        do {
            let results = try self.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results!.count > 0 {
                results?[0].setValue(recipe.name, forKey: "name")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }

        self.save()
    }
    
    func addIngredient(id: String? = nil, name: String? = nil, quantity: Int? = nil, unit: String? = nil, recipe: Recipe) -> Ingredient {
        let ingredient = NSEntityDescription.insertNewObject(forEntityName: "Ingredient", into: managedObjectContext) as! Ingredient
        ingredient.id = id ?? UUID().uuidString
        ingredient.name = name ?? ""
        ingredient.quantity = quantity ?? 0
        ingredient.unit = unit ?? MeasurementUnit.none.rawValue
        ingredient.recipe = recipe
        
        self.save()
        
        return ingredient
    }
    
    func flush() {
        for type in TypeCatalogue.allCases {
            let entity = type.rawValue
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            request.returnsObjectsAsFaults = false
            
            do {
                let results = try self.managedObjectContext.fetch(request)
                for object in results {
                    guard let results = object as? NSManagedObject else { continue }
                    self.managedObjectContext.delete(results)
                }
            } catch let error {
                print("Error: Unable to flush \(entity): \(error)")
            }
        }
    }
}
