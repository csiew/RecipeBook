//
//  Recipe+CoreDataClass.swift
//  Recipe Book
//
//  Created by Clarence Siew on 10/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Recipe)
public class Recipe: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }
    
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var recipeDescription: String
    @NSManaged public var source: String
    @NSManaged public var directions: [String]
    @NSManaged public var ingredients: Set<Ingredient>
    @NSManaged public var dateCreated: Date
    
    convenience init(permanent: Bool, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        if permanent == true {
            self.init(entity: NSEntityDescription.entity(forEntityName: "Recipe", in: context)!, insertInto: context)
        } else {
            self.init(entity: NSEntityDescription.entity(forEntityName: "Recipe", in: context)!, insertInto: nil)
        }
    }
    
    convenience init(
        permanent: Bool,
        insertIntoManagedObjectContext context: NSManagedObjectContext!,
        id: String? = nil,
        name: String? = nil,
        description: String? = nil,
        source: String? = nil,
        ingredients: Set<Ingredient>? = nil,
        directions: [String]? = nil
    ) {
        if permanent == true {
            self.init(entity: NSEntityDescription.entity(forEntityName: "Recipe", in: context)!, insertInto: context)
        } else {
            self.init(entity: NSEntityDescription.entity(forEntityName: "Recipe", in: context)!, insertInto: nil)
        }
        self.id = id ?? UUID().uuidString
        self.name = name ?? ""
        self.recipeDescription = description ?? ""
        self.source = source ?? ""
        self.ingredients = ingredients ?? Set<Ingredient>()
        self.directions = directions ?? Array<String>()
        self.dateCreated = Date()
    }
    
    func getIngredients() -> [Ingredient] {
        return self.ingredients.compactMap({ $0 }).sorted(by: { $0.name < $1.name })
    }
}


// MARK: Generated accessors for ingredients
extension Recipe {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: Set<Ingredient>)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: Set<Ingredient>)
    
    public func updateIngredient(_ id: String, name: String? = nil, quantity: Int? = nil, unit: String? = nil) {
        let results = self.ingredients.compactMap({ $0 }).filter({ $0.id == id })
        if results.count == 1 {
            results[0].name = name ?? ""
            results[0].quantity = quantity ?? 0
            results[0].unit = unit ?? "none"
        }
    }

}
