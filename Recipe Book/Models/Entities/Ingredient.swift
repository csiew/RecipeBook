//
//  Ingredient+CoreDataClass.swift
//  Recipe Book
//
//  Created by Clarence Siew on 10/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Ingredient)
public class Ingredient: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Ingredient")
    }
    
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var quantity: Int
    @NSManaged public var unit: String
    @NSManaged public var recipe: Recipe

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(UUID().uuidString, forKey: "id")
        setPrimitiveValue("", forKey: "name")
        setPrimitiveValue(0, forKey: "quantity")
        setPrimitiveValue("none", forKey: "unit")
    }
    
    convenience init(permanent: Bool, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        if permanent == true {
            self.init(entity: NSEntityDescription.entity(forEntityName: "Ingredient", in: context)!, insertInto: context)
        } else {
            self.init(entity: NSEntityDescription.entity(forEntityName: "Ingredient", in: context)!, insertInto: nil)
        }
    }
    
    convenience init(
        permanent: Bool,
        insertIntoManagedObjectContext context: NSManagedObjectContext!,
        id: String? = nil,
        name: String? = nil,
        quantity: Int? = nil,
        unit: String? = nil,
        recipe: Recipe
    ) {
        if permanent == true {
            self.init(entity: NSEntityDescription.entity(forEntityName: "Ingredient", in: context)!, insertInto: context)
        } else {
            self.init(entity: NSEntityDescription.entity(forEntityName: "Ingredient", in: context)!, insertInto: nil)
        }
        self.id = id ?? UUID().uuidString
        self.name = name ?? ""
        self.quantity = quantity ?? 0
        self.unit = unit ?? "none"
        self.recipe = recipe
    }
}
